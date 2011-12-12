<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectProperties>
		<property name="promotionCode">
			<rule type="custom" contexts="*" failureMessage="Promotion Code is Not Unique">
				<param name="methodName" value="hasUniquePromotionCode" />
			</rule>
		</property>
		<property name="startDateTime">
			<rule type="date" contexts="*" />
		</property>
		<property name="endDateTime">
			<rule type="date" contexts="*" />
		</property>
	</objectProperties>
</validateThis>