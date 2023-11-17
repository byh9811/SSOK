import React, { useState, useEffect } from 'react'
import axios from 'axios';

const Payment = ({totalMoney, selectItem, removeAll}) => {

    const [first, setFirst] = useState("");
    const [second, setSecond] = useState("");
    const [third, setThird] = useState("");
    const [fourth, setFouth] = useState("");
    const [paymentItemList, setPaymentItemList] = useState([]);

    useEffect(() => {

        let array = [];
        for(let i=0; i<selectItem.length; i++){
            const itemSeq = selectItem[i].itemSeq;
            const itemCnt = selectItem[i].itemCnt;
            let item ={
                "itemSeq":itemSeq,
                "itemCnt":itemCnt
            }
            array=[...array,item];
        }
        console.log(array);
        setPaymentItemList(array);

      }, [selectItem])


    function onChangeFirst(e){
        const value = Number(e.target.value);
        if (Number.isNaN(value)) return; 
        setFirst(e.target.value)
    }
    function onChangeSecond(e){
        const value = Number(e.target.value);
        if (Number.isNaN(value)) return; 
        setSecond(e.target.value)
    }
    function onChangeThird(e){
        const value = Number(e.target.value);
        if (Number.isNaN(value)) return; 
        setThird(e.target.value)
    }
    function onChangeFourth(e){
        const value = Number(e.target.value);
        if (Number.isNaN(value)) return; 
        setFouth(e.target.value)
    }


    async function buy(){
        const cardNum = first+'-'+second+'-'+third+'-'+fourth;

        if(first.length!=4 ||second.length!=4 ||third.length!=4 ||fourth.length!=4){
            alert("카드번호를 정확히 입력해주세요");
            return;
        }

        if(totalMoney==0){
            alert("물품을 선택해주세요");
            return;
        }

        await axios.post('https://k9c107.p.ssafy.io/pos/payment-service/payment', {
            "cardNum": cardNum,
            "cardType": "01",
            "amount": totalMoney,
            "type": "01",
            "installPeriod": "0",
            "shopName": "엔젤리너스",
            "shopNumber": "123-45-67890",
            "paymentItemList":paymentItemList
        }).then((response)=>{
          console.log(response.data);
          removeAll();
          setPaymentItemList([]);
        });
    }

  return (
    <div className='paymentWrapper'>
        <div className='payWrapper'>
            <div className='card'>
                <span>
                <span>카드번호 : </span>
                <input className='cardNum' maxLength={4} value={first} onChange={onChangeFirst}></input>-
                <input className='cardNum'value={second} onChange={onChangeSecond} maxLength='4'></input>-
                <input className='cardNum'value={third} onChange={onChangeThird} maxLength='4'></input>-
                <input className='cardNum'value={fourth} onChange={onChangeFourth} maxLength='4'></input>
                </span>
            </div>          
        </div>
        <div className='total'>
                <div className='totalTitle'>총 금액</div>
                <div className='totalMoney'>{totalMoney}</div>
            </div>  
        <div className='payBtn' onClick={buy}>
            결제
        </div>

    </div>
  )
}

export default Payment