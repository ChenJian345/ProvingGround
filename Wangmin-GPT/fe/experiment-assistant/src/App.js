/*
 * @Author: Mark Chen chenjian345@gmail.com
 * @Date: 2024-07-08 20:07:09
 * @LastEditors: Mark Chen chenjian345@gmail.com
 * @LastEditTime: 2024-07-08 20:56:15
 * @FilePath: /FE/Users/mark/iDev/openSourceByMark/test/ProvingGround/WM-GPT/fe/experiment-assistant/src/App.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import logo from "./logo.svg";
import "./App.css";
import React, { useState, useEffect } from "react";

function App() {
  const [courses, setCourses] = useState([]);

  useEffect(() => {
    console.log("fetching courses - start");
    fetch("/api/courses")
      .then((res) => res.json())
      .then((data) => {
        console.log('fetching courses -- end')
        console.dir(data)
        setCourses(data)
      });
  }, [courses]);

  return (
    <div>
      <h1>课程列表</h1>
      <ul>
        {courses.map((course) => (
          <li key={course.id}>{course.name}</li>
        ))}
      </ul>
    </div>
  );

  // return (
  //   <div className="App">
  //     <header className="App-header">
  //       <img src={logo} className="App-logo" alt="logo" />
  //       <p>
  //         Edit <code>src/App.js</code> and save to reload.
  //       </p>
  //       <a
  //         className="App-link"
  //         href="https://reactjs.org"
  //         target="_blank"
  //         rel="noopener noreferrer"
  //       >
  //         Learn React
  //       </a>
  //     </header>
  //   </div>
  // );
}

export default App;
