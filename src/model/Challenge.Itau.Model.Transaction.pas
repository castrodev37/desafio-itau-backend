unit Challenge.Itau.Model.Transaction;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Challenge.Itau.Model.Exceptions;

type
  TChallengeItauModelTransaction = class
  private
    FValue: Currency;
    FDate: TDateTime;

    procedure SetValue(const Value: Currency);
    procedure ValidateDate(const ADate: TDateTime);
    function GetValue: Currency;
    function ParseStringToDate(AValueDate: string): TDateTime;
  public
    function GetDate: TDateTime;
    procedure SetDate(const AValue: string);
    property Value: Currency read GetValue write SetValue;
  end;

implementation

{ TChallengeItauModelTransaction }

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
  if LDate > LCurrentDate then
    raise EValidationError.Create('Transação deve ser anterior à data atual');
end;

end.
