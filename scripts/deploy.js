const hre = require("hardhat");

async function main() {

  const TokenAmountContract = await ethers.getContractFactory("tokenAmountContract");
  const tokenAmountContract = await TokenAmountContract.deploy();//в скобки вписываем значения конструктора
  await tokenAmountContract.deployed();// доп логика

  console.log("tokenAmountContract deployed to:", tokenAmountContract.address);//выводит в консоль название контракта и адресс контракта который задеплоили

  const NarfexLockerAddress = await ethers.getContractFactory("NarfexLocker");
  const narfexLockerAddress = await NarfexLockerAddress.deploy("0x3764Be118a1e09257851A3BD636D48DFeab5CAFE", 1, 2);//в скобки вписываем значения конструктора
  await narfexLockerAddress.deployed();// доп логика

  console.log("narfexLocker deployed to:", narfexLockerAddress.address);//выводит в консоль название контракта и адресс контракта который задеплоили

  const masterChef = await ethers.getContractFactory("MasterChef");
  const master = await masterChef.deploy("0x3764Be118a1e09257851A3BD636D48DFeab5CAFE", tokenAmountContract.address, 1, 2, narfexLockerAddress.address);//в скобки вписываем значения конструктора
  await master.deployed();// доп логика

  console.log("MasterShef deployed to:", master.address);//выводит в консоль название контракта и адресс контракта который задеплоили

}

main()// просто запускаем async function 
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
