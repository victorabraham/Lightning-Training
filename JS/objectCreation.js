
//Bracket notaion
var product = {};
product.name = 'car';
product.description = 'My new car';
product.display = function(){
  console.log('##Product Display## ==> '+this.name);
}
product.display();
console.log(product);


//Object.Create
var newProduct = Object.create(Object.prototype);
newProduct.name = 'bike';
newProduct.description = 'My new bike';
console.log(newProduct);

//new Object
var anotherProduct = new Object();
anotherProduct.name = 'computer';
anotherProduct.description = 'New';
console.log(anotherProduct);





//var product = {};


console.log(Object.keys(product));
var obj = {};
Object.defineProperty(obj, 'name', {
  value: 'default value',
  writable: true,
  enumerable: true,
  configurable: true
});
console.log(obj);





console.log('###############################################################################')
