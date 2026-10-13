// FiberHome Provisioning Script
const now = Date.now();
const cacheTime = now - 300000;

// FiberHome Optical Information
declare("InternetGatewayDevice.WANDevice.*.X_FH_GponInterfaceConfig.RXPower", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.X_FH_GponInterfaceConfig.TXPower", {value: cacheTime});

// FiberHome PPPoE Credentials
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Username", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Password", {value: cacheTime});

// FiberHome SuperAdmin
declare("InternetGatewayDevice.DeviceInfo.X_FH_Account.X_FH_WebUserInfo.WebSuperPassword", {value: cacheTime});
