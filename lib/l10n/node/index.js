const fs = require('fs');
const path = require('path');
const chokidar = require('chokidar');
const { exec } = require('child_process')
const { promisify } = require('util')

// 将嵌套的 JSON 转换为铺平格式，并确保每种语言的键一致
const flattenJSON = (obj, prefix = '', parentKey = '') => {
  let result = {};
  const lang = new Set(['zh', 'ja', 'en']);  // 语言集合

  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      const newKey = prefix ? `${prefix}_${key}` : key; // 使用下划线拼接键

      // 如果是对象，递归调用 flattenJSON 处理嵌套
      if (typeof obj[key] === 'object' && obj[key] !== null) {
        // 递归处理子对象
        Object.assign(result, flattenJSON(obj[key], newKey), key);
      } else {
        if (newKey.length === 1) {
          console.log(2)
        }
        // 如果是语言项，处理 zh, ja, en
        if (key === 'text') {
          result[prefix] = obj.text
          result[`@${prefix}`] = {
            placeholders: obj.placeholders
          }
          break
        } else {
          if (lang.has(key)) {
            result[newKey] = obj[key];
          } else {
            // 其他普通键直接添加
            result[newKey] = obj[key];
          }
        }
        
      }
    }
  }

  return result;
};



// 读取 JSON 文件
const readJSON = (filePath, retries = 5, delay = 5000) => {
  return new Promise((resolve, reject) => {
    const attemptRead = (remainingRetries) => {
      fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
          if (remainingRetries > 0) {
            console.log(`Error reading file, retrying... (${remainingRetries} retries left)`);
            setTimeout(() => attemptRead(remainingRetries - 1), delay);  // 等待 delay 毫秒后重试
          } else {
            reject(`Failed to read file after ${retries} attempts: ${err.message}`);
          }
        } else {
          try {
            const jsonData = JSON.parse(data);  // 解析文件内容
            resolve(jsonData);
          } catch (parseError) {
            reject(`Error parsing JSON: ${parseError.message}`);
          }
        }
      });
    };

    attemptRead(retries);  // 启动首次读取尝试
  });
};


// 写入 ARB 文件
const writeArbFile = (filePath, arbContent) => {
  return new Promise((resolve, reject) => {
    const jsonString = JSON.stringify(arbContent, null, 2); // 格式化输出
    fs.writeFile(filePath, jsonString, 'utf8', (err) => {
      if (err) reject(err);
      resolve();
    });
  });
};

const lang = path.resolve(__dirname, '../lib/l10n')
const templateFile = path.join(lang, 'translations.json')


// 生成 ARB 文件
const generateArbFiles = async () => {
  try {
    
    const jsonData = await readJSON(templateFile); // 读取 JSON 文件
    const flattenedData = flattenJSON(jsonData); // 转换为铺平格式

    // 中文 ARB 文件内容
    const zhArbContent = {
      "@@locale": "zh",
    };
    // 日文 ARB 文件内容
    const jaArbContent = {
      "@@locale": "ja",
    };
    // 英文 ARB 文件内容
    const enArbContent = {
      "@@locale": "en",
    };

    // Object.keys(flattenedData) {}
    // 填充 ARB 文件
    for (let key in flattenedData) {
      if (flattenedData.hasOwnProperty(key)) {
        const split = key.split('_')
        const baseKey = split.splice(0, split.length - 1).join('_')
        const lang = split.at(-1)
        // if (key.startsWith('@')) {
        //   const obj = flattenedData[key]
        //   zhArbContent[baseKey] = obj
        // }

        if (lang === 'zh') {
          zhArbContent[baseKey] = flattenedData[key];
        } else if (lang === 'ja') {
          jaArbContent[baseKey] = flattenedData[key];
        } else if (lang === 'en') {
          enArbContent[baseKey] = flattenedData[key];
        }
      }
    }

    // 写入三个 ARB 文件
    
    await writeArbFile(path.join(lang, 'intl_zh.arb'), zhArbContent);
    await writeArbFile(path.join(lang, 'intl_ja.arb'), jaArbContent);
    await writeArbFile(path.join(lang, 'intl_en.arb'), enArbContent);

    console.log()
    const command = [
      `cd ../`,
      'dart pub global run intl_utils:generate'
    ]
    await promisify(exec)(command.join(' && '))
    console.log('ARB files generated successfully!');
  } catch (err) {
    console.error('Error generating ARB files:', err);
  }
};

// 监控文件变化
const watchFileChanges = () => {
  const watcher = chokidar.watch(templateFile, {
    persistent: true, // 保持监听
    ignoreInitial: true, // 忽略首次加载事件
  });

  watcher.on('change', (filePath) => {
    console.log(`File changed: ${filePath}`);
    generateArbFiles(); // 文件发生变化时，自动生成新的 ARB 文件
  });

  console.log('Watching for changes in translations.json...');
};

// 初始化函数
const init = () => {
  generateArbFiles(); // 初次生成文件
  watchFileChanges(); // 启动文件变化监控
};

// 执行初始化函数
init();
