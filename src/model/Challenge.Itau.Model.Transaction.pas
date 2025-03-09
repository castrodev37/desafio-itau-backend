unit Challenge.Itau.Model.Transaction;

interface

uses
  System.SysUtils,
  System.DateUtils,
//  System.Classes,
//  System.SyncObjs,
  Challenge.Itau.Model.Exceptions;

type
  TChallengeItauModelTransaction = class
  private
//    class var FInstance: TChallengeItauModelTransaction;
//    class var FCriticalSection: TCriticalSection; // Para thread safety
    FValue: Currency;
    FDate: TDateTime;
//    constructor Create;

    procedure SetValue(const Value: Currency);
    procedure ValidateDate(const ADate: TDateTime);
    function GetValue: Currency;
    function ParseStringToDate(AValueDate: string): TDateTime;
  public
//    class function GetTransactionModel: TChallengeItauModelTransaction;
//    class procedure DestroyTransactionModel;

    function GetDate: TDateTime;
    procedure SetDate(const AValue: string);
    property Value: Currency read GetValue write SetValue;
  end;

implementation

{ TChallengeItauModelTransaction }

//class procedure TChallengeItauModelTransaction.DestroyTransactionModel;
//begin
//  FCriticalSection.Enter;
//  try
//    if Assigned(FInstance) then
//    begin
//      FInstance.Free;
//      FInstance := nil;
//    end;
//  finally
//    FCriticalSection.Leave;
//  end;
//
//  if Assigned(FCriticalSection) then
//  begin
//    FCriticalSection.Free;
//    FCriticalSection := nil;
//  end;
//end;

function TChallengeItauModelTransaction.ParseStringToDate(AValueDate: string): TDateTime;
var
  LFormatSettings: TFormatSettings;
begin
  if AValueDate.IsEmpty then
    raise Exception.Create('Data inválida para uma transação');

  LFormatSettings := TFormatSettings.Create;
  LFormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  LFormatSettings.LongTimeFormat := 'hh:mm:ss';
  LFormatSettings.DateSeparator := '-';
  LFormatSettings.TimeSeparator := ':';
  Result := StrToDateTime(AValueDate, LFormatSettings);
end;

function TChallengeItauModelTransaction.GetDate: TDateTime;
begin
  Result := FDate;
end;

//class function TChallengeItauModelTransaction.GetTransactionModel: TChallengeItauModelTransaction;
//begin
//  if FCriticalSection = nil then
//    FCriticalSection := TCriticalSection.Create;
//
//  FCriticalSection.Enter; // Bloqueia para garantir acesso exclusivo
//  try
//    if not Assigned(FInstance) then
//      FInstance := TChallengeItauModelTransaction.Create;
//    Result := FInstance;
//  finally
//    FCriticalSection.Leave; // Libera o bloqueio
//  end;
//end;

function TChallengeItauModelTransaction.GetValue: Currency;
begin
  Result := FValue;
end;

procedure TChallengeItauModelTransaction.SetDate(const AValue: string);
begin
  try
    FDate := ParseStringToDate(AValue);
    ValidateDate(FDate);
  except
    on E: Exception do
      raise EValidationError.Create('Falha ao atribuir a data: ' + E.Message);
  end;
end;

procedure TChallengeItauModelTransaction.SetValue(const Value: Currency);
begin
  if Value <= 0 then
    raise EValidationError.Create('Valor inválido para uma transação');
  FValue := Value;
end;

procedure TChallengeItauModelTransaction.ValidateDate(const ADate: TDateTime);
var
  LCurrentDate, LDate: TDateTime;
begin
  LDate := DateOf(ADate);
  LCurrentDate := DateOf(Now);
  if LDate >= LCurrentDate then
    raise EValidationError.Create('Transação deve ser anterior à data atual');
end;

//initialization
//
//finalization
//  TChallengeItauModelTransaction.DestroyTransactionModel;

end.
