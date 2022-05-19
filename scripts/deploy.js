const hre = require("hardhat");

async function main() {
  const masterChef = await ethers.getContractFactory("MasterChef");
  const master = await masterChef.deploy("_Narfex","_tokenAmountContract", "_startBlock", "_NarfexPerBlock");//в скобки вписываем значения конструктора
  await master.deployed();// доп логика

  console.log("MasterChef deployed to:", master.address);//выводит в консоль название контракта и адресс контракта который задеплоили
}

main()// просто запускаем async function 
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
