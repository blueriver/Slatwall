<cfoutput>
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	<soap:Body>
		<CalculatePostageRates xmlns="www.envmgr.com/LabelService">
			<PostageRatesRequest>
				<RequesterID>Slatwall</RequesterID>
				<CertifiedIntermediary>
					<AccountID>#variables.accountID#</AccountID>
					<PassPhrase>#variables.passPhrase#</PassPhrase>
				</CertifiedIntermediary>
				<MailClass></MailClass>
				<WeightOZ>#totalItemsWeight#</WeightOZ>
				<MailpieceShape>Parcel</MailpieceShape>
				<Machineable>TRUE</Machineable>
				<Services>
					<CertifiedMail>OFF</CertifiedMail>
					<COD>OFF</COD>
					<DeliveryConfirmation>OFF</DeliveryConfirmation>
					<ElectronicReturnReceipt>OFF</ElectronicReturnReceipt>
					<InsuredMail>OFF</InsuredMail>
					<RestrictedDelivery>OFF</RestrictedDelivery>
					<ReturnReceipt>OFF</ReturnReceipt>
					<SignatureConfirmation>OFF</SignatureConfirmation>
				</Services>
				<InsuredValue>#totalItemsValue#</InsuredValue>
				<FromPostalCode>#variables.fromPostalCode#</FromPostalCode>
				<ToPostalCode>#arguments.requestBean.getShipToPostalCode()#</ToPostalCode>
				<ToCountryCode>#arguments.requestBean.getShipToCountryCode()#</ToCountryCode>
			</PostageRatesRequest>
		</CalculatePostageRates>
	</soap:Body>
</soap:Envelope>
</cfoutput>