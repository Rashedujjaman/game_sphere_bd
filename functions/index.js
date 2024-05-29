const {onRequest} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin
admin.initializeApp();

// IPN handler function
exports.handleIPN = onRequest(async (req, res) => {
  const ipnData = req.body;
  logger.info("IPN Data Received", {structuredData: true, ipnData});

  // Validate IPN data and update Firestore
  try {
    // Assuming `tran_id` is the Firestore document ID
    const transactionId = ipnData.tran_id;

    // Update Firestore document with IPN data
    await admin.firestore().collection("orders").doc(transactionId).update({
      status: ipnData.status,
      ipnData: ipnData,
    });

    res.status(200).send("IPN Handled Successfully");
  } catch (error) {
    logger.error("Error handling IPN:", error);
    res.status(500).send("Error handling IPN");
  }
});
