import React from 'react';
import './App.css';

function App() {
  return (
    <div className="App">

      <div>
        <button>어플 설치하기</button>
        <a href="https://ssok.site">결제는 SSOK POS기로 SSOK</a>
      </div>
      <br/><br/><br/>
      <div class="satellites" >
          <img class="satellite" style={{'--i': 0, top: '80px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 20, top: '30px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 40,top: '120px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 60,top: '70px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 80,top: '10px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 100, top: '90px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 120, top: '40px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 140, top: '30px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 160, top: '20px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 180, top: '90px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 200, top: '110px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 220, top: '20px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 240, top: '70px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 300, top: '20px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 260, top: '80px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 280, top: '10px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 320, top: '120px'}} src="캡처.PNG"/>
          <img class="satellite" style={{'--i': 340, top: '20px'}} src="캡처.PNG"/>
      </div>


      <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    </div>
  );
}

export default App;
