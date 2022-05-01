// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;



contract Ecommerce{

    address payable manager;
bool destroyed=false; 
constructor() public
{
     manager=payable(msg.sender); 
}
 uint count=1;
struct Product{

    string title;
    string desc;
    uint price;
    address payable seller;
    address buyer;
    uint productId;
    bool delivered;
}

Product[] public products;

modifier isNotDestroyed{ require(!destroyed,"Contract does not exist"); _; }

 function registerProduct(string memory _title,string memory _desc,uint _price) public  isNotDestroyed{
     Product memory tempProduct;
     tempProduct.title=_title;
     tempProduct.desc=_desc;
     tempProduct.price=_price*10**18;
     tempProduct.productId=count;
     tempProduct.seller=payable(msg.sender);
     products.push(tempProduct);
     count++;

 }

function buy(uint _productId) public payable  isNotDestroyed{
    require(products[_productId-1].price==msg.value,"Pay the exact price");
    require(products[_productId-1].seller!=msg.sender,"Seller Cannot buy his own Product");
    products[_productId-1].buyer=msg.sender;
}

function delivery(uint _productId) public{
    require(products[_productId-1].buyer==msg.sender,"Only buyer can confirm");
    products[_productId-1].delivered=true; 
    products[_productId-1].seller.transfer(products[_productId-1].price);

}

function destroy() public isNotDestroyed{ 
    require(manager==msg.sender,"only manager can call this");
 manager.transfer(address(this).balance); 
 destroyed=true; }

fallback() payable external{ 
 payable(msg.sender).transfer(msg.value);
     } 

     receive() external payable {}

}
