import React from 'react';
import './App.css';



function App() {
  return (
    <div className="App">
      <div className='mainText'>
        <img className='logoImg' src="로고.png"></img>
        <div className="description">
          내 지갑 안의 모든 것들을 SSOK!!
        </div>
        <br></br>
        <div>
          <a href="" onClick={popUp}><img className="google" src="googleplay.png"></img></a>
        </div>
        <div className='buttonWrapper'>
          {/* <button onClick={popUp} >어플 설치하기</button> */}
          {/* <a href="https://ssok.site">결제는 SSOK POS기로 SSOK</a> */}
        </div>
      </div>
      <div class="satellites" >
          <img class="satellite" style={{'--i': 0, top: '80px'}} src="card1.png"/>
          <img class="satellite" style={{'--i': 20, top: '30px'}} src="card2.png"/>
          <img class="satellite" style={{'--i': 40,top: '120px'}} src="namecard1.png"/>
          <img class="satellite" style={{'--i': 60,top: '70px'}} src="card3.png"/>
          <img class="satellite" style={{'--i': 80,top: '10px'}} src="receipt1.png"/>
          <img class="satellite" style={{'--i': 100, top: '90px'}} src="card4.png"/>
          <img class="satellite" style={{'--i': 120, top: '40px'}} src="receipt2.png"/>
          <img class="satellite" style={{'--i': 140, top: '30px'}} src="card5.png"/>
          <img class="satellite" style={{'--i': 160, top: '20px'}} src="namecard3.png"/>
          <img class="satellite" style={{'--i': 180, top: '90px'}} src="card6.png"/>
          <img class="satellite" style={{'--i': 200, top: '110px'}} src="namecard2.png"/>
          <img class="satellite" style={{'--i': 220, top: '20px'}} src="card7.png"/>
          <img class="satellite" style={{'--i': 240, top: '70px'}} src="earth.png"/>
          <img class="satellite" style={{'--i': 300, top: '20px'}} src="card8.png"/>
          <img class="satellite" style={{'--i': 260, top: '80px'}} src="namecard3.png"/>
          <img class="satellite" style={{'--i': 280, top: '10px'}} src="receipt2.png"/>
          <img class="satellite" style={{'--i': 320, top: '120px'}} src="namecard2.png"/>
          <img class="satellite" style={{'--i': 340, top: '20px'}} src="캡처.PNG"/>
      </div>


      <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    </div>
  );
}
function popUp(){
  alert("앱 출시를 위해 열심히 노력중입니다!")
}
export default App;
