/*
 * @Author: Mark Chen chenjian345@gmail.com
 * @Date: 2024-07-08 19:50:33
 * @LastEditors: Mark Chen chenjian345@gmail.com
 * @LastEditTime: 2024-07-08 20:32:25
 * @FilePath: /FE/Users/mark/iDev/openSourceByMark/test/ProvingGround/WM-GPT/backend/index.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

// Express.js
const express = require('express');
const app = express();
const PORT = 10000;

// 使用MongoDB
// const mongoose = require('mongoose');

// TODO: 集成大模型axios

const courses = [
    {
        id: 1,
        name: '实验课1'
    },
    {
        id: 2,
        name: '实验课2'
    },
    {
        id: 3,
        name: '实验课3'
    }
]

app.get('/api/courses', async (req, res) => {
    // const courses = await Course.find()
    res.json(courses)

    console.log('请求成功，返回数据')
    console.log(res.json(courses))
});

app.listen(PORT, ()=>{
    console.log(`Server is running on http://localhost:${PORT}`);
})

// // MongoDB
// mongoose.connect('mongodb://localhost:27017/courses', {
//     useNewUrlParser: true,
//     useUnifiedTopology: true
// });

// const courseSchema = new mongoose.Schema({
//     name: String
// });

// const Course = mongoose.model('Course', courseSchema);
