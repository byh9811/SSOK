import React, { useState } from 'react'

const Item = ({item, addItem}) => {

  const [first, setfirst] = useState(item)

  function addNewItem(){
    addItem({"itemSeq":item.itemSeq,"itemName":item.itemName, "itemPrice":item.itemPrice,"itemTotalPrice":item.itemPrice, "itemCnt":1})
  }

  return (
    <div className='itemWrapper' onClick={addNewItem}>
      <div className='itemInfoWrapper'>
        <div className='itemName'>{first.itemName}</div>
        <div className='itemPrice'>{first.itemPrice}원</div>
      </div>
    </div>
  )
}

export default Item