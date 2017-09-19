<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Test_Email</fullName>
        <description>Test Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>insightssecurity@00d6a0000002vfeuau.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>satishxi7@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SupportCaseCreatedPhoneInquiries</template>
    </alerts>
    <rules>
        <fullName>Sample Work Flow</fullName>
        <actions>
            <name>Test_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Phone</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
