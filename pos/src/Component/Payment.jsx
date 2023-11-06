import React from 'react'

const Payment = () => {
  return (
    <div className='paymentWrapper'>
        <div className='payWrapper'>
            <div className='card'>
                <span>
                <span>카드번호 : </span>
                <input className='cardNum'></input>-
                <input className='cardNum'></input>-
                <input className='cardNum'></input>-
                <input className='cardNum'></input>
                </span>
            </div>          
        </div>
        <div className='total'>
                <div className='totalTitle'>총 금액</div>
                <div className='totalMoney'>10000</div>
            </div>  
        <div className='payBtn'>
            결제
        </div>

    </div>
  )
}

export default Payment