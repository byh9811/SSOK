import React from 'react'

const SelectItem = ({item, removeItem}) => {

function delItem(){
  removeItem(item);
}

  return (
    <div className='selectItemWrapper'>
      <div className="selectItemInfo">
        <div className='selectItemName'>{item.itemName}</div>
        <div className='selectItemCnt'>{item.itemCnt}</div>
        <div className='selectItemPrice'>{item.itemPrice}</div>
        <div className='rmBtn'><button onClick={delItem}>취소</button></div>
      </div>
    </div>
  )
}

export default SelectItem