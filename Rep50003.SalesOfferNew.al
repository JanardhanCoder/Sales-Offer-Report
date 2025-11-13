namespace GreenBuild.GreenBuild;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.AccessControl;
using Microsoft.Finance.Currency;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Address;
using Microsoft.Bank.BankAccount;
using Microsoft.Sales.Customer;
report 50033 "Sales Offer"
{
    Caption = 'Sales Offer';
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/SalesOfferReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Unit; Unit)
        {
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(UnitDescription; Description)
            {

            }
            column(UnitType; "Unit Type")
            {
            }
            column(Buildingtype; "Building type")
            {
            }
            column(TotalArea; "Total Area")
            {
            }
            column(TotalUnitValue; "Total Unit Value")
            {
            }
            column(Unit_View; "Unit View")
            { }
            column(SubCategory; "Unit Sub Category")
            {

            }
            column(UnitPicture; UnitPicture) { }
            column(RoomNo; RoomNo) { }
            column(Drawing; Drawing)
            {

            }
            column(CurrencyCode; CurrencyCode)
            {

            }
            column(bank1; bank[1])
            {
            }
            column(bank2; bank[2])
            {
            }
            column(bank3; bank[3])
            {
            }
            column(bank4; bank[4])
            {
            }
            column(bank5; bank[5])
            {
            }
            column(bank6; bank[6])
            {

            }
            column(bank7; bank[7])
            {

            }
            column(BankAccText; BankAccText)
            {

            }
            column(UserName; UserName) { }
            column(CustomerName; "Customer Name") { }
            column(UnitOfMeasure; "Unit Of Measure") { }
            column(Picture; CompanyInformation.Picture) { }
            dataitem("Payment Schedule Line"; "Payment Schedule Table")
            {
                DataItemLink = "unit no." = field("No.");
                //DataItemLinkReference = Unit;
                //DataItemTableView = where("Line No.");
                DataItemTableView = sorting("Due Date");
                column(PlanNo; "Plan No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Due_Date; "Due Date")
                {

                }
                column(Value; "% Value")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Payment_Type; "Payment Type")
                {

                }
                column(CashFlowPaymentYear; Year)
                {

                }
                column(CashFlowAmount; CashFlowAmount)
                {

                }
                column(AccountType; "Account Type")
                {

                }

                column(Escrow_BankName; EscrowBankAcc.Name) { }
                column(Escrow_AccountHolder; EscrowBankAcc."Account Holder") { }

                column(Escrow_AccountNumber; EscrowBankAcc."Bank Account No.") { }
                column(Escrow_IBAN; EscrowBankAcc.IBAN) { }
                column(Escrow_AccountName; EscrowBankAcc."Account Name") { }
                column(Escrow_AccountType; EscrowBankAcc."Account Type") { }
                column(Escrow_SWIFT; EscrowBankAcc."SWIFT Code") { }
                column(Escrow_Branch; EscrowBankAcc."Bank Branch No.") { }
                // Current Bank Account columns
                column(CurrentBankAcc_BankName; CurrentBankAcc.Name) { }
                column(Current_AccountHolder; CurrentBankAcc."Account Holder") { }

                column(Current_AccountNumber; CurrentBankAcc."Bank Account No.") { }
                column(Current_IBAN; CurrentBankAcc.IBAN) { }
                column(Current_AccountName; CurrentBankAcc."Account Name") { }
                column(Current_AccountType; CurrentBankAcc."Account Type") { }
                column(Current_SWIFT; CurrentBankAcc."SWIFT Code") { }
                column(Current_Branch; CurrentBankAcc."Bank Branch No.") { }

                trigger OnAfterGetRecord()
                begin
                    if "Due Date" <> 0D then
                        Year := Date2DMY("Due Date", 3);
                    CashFlowAmount := Amount;
                end;
            }
            trigger OnAfterGetRecord()
            var
                curr: Record Currency;
                odr: Record "Sales Header";
                Cust: Record Customer;

            begin
                Clear(CurrencyCode);
                Cust.SetRange("No.", "Customer No.");
                if Cust.FindFirst() then
                    CurrencyCode := Cust."Currency Code"
                else
                    CurrencyCode := GLSetup."LCY Code";

                EscrowBankAcc.Reset();
                // EscrowBankAcc.SetRange("Currency Code", Cust."Currency Code");
                EscrowBankAcc.SetRange(Print, true);
                EscrowBankAcc.SetRange("Account Type", EscrowBankAcc."Account Type"::"Escrow Account");
                EscrowBankAcc.FindFirst();

                // Get Current Account
                CurrentBankAcc.Reset();
                //CurrentBankAcc.SetRange("Currency Code", Cust."Currency Code");
                CurrentBankAcc.SetRange(Print, true);
                CurrentBankAcc.SetRange("Account Type", CurrentBankAcc."Account Type"::"Current Account");
                CurrentBankAcc.FindFirst();
            end;

        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
        user: Record User;
    begin
        CompanyInformation.SetAutoCalcFields(Picture);
        CompanyInformation.Get();
        GLSetup.Get();
        Clear(username);
        user.SetRange("User Name", Database.UserId);
        if user.FindFirst() then
            UserName := user."Full Name";
    end;


    var
        //unitRec: Record Unit;
        CompanyInformation: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        CompanyAddress: array[8] of Text[100];
        GLSetup: Record "General Ledger Setup";
        UserName: Text[100];
        Year: Integer;
        CashFlowAmount: Decimal;
        CurrencyCode: Code[10];
        BankAcc: Record "Bank Account";
        bank: array[8] of Text[100];
        BankAccLbl: Label 'Bank Account:';
        BankAccText: Text[100];
        EscrowBankAcc: Record "Bank Account";
        CurrentBankAcc: Record "Bank Account";
        Vendor: Record Vendor;


}
