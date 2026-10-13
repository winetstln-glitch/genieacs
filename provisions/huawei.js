// Huawei Provisioning Script
const now = Date.now();
const cacheTime = now - 300000;

// Huawei Optical Information
declare("InternetGatewayDevice.WANDevice.*.X_GponInterafceConfig.RXPower", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.X_GponInterafceConfig.TXPower", {value: cacheTime});

// Huawei PPPoE Credentials
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Username", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Password", {value: cacheTime});

// Huawei Web User Info
declare("InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.2.Password", {value: cacheTime});
