// CData Provisioning Script
const now = Date.now();
const cacheTime = now - 300000;

// Optical Information
declare("InternetGatewayDevice.WANDevice.*.X_CT-COM_GponInterfaceConfig.RXPower", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Username", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Password", {value: cacheTime});
