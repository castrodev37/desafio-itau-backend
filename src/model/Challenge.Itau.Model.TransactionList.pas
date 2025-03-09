unit Challenge.Itau.Model.TransactionList;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  Challenge.Itau.Model.Transaction;

type
  TChallengeItauModelTransactionList = class
  private
    class var FList: TObjectList<TChallengeItauModelTransaction>;
    class function GetList: TObjectList<TChallengeItauModelTransaction>; static;
  public
    class constructor Create;
    class destructor Destroy;
    class property List: TObjectList<TChallengeItauModelTransaction> read GetList;
  end;

implementation

{ TChallengeItauModelTransactionList }

class constructor TChallengeItauModelTransactionList.Create;
begin
  FList := TObjectList<TChallengeItauModelTransaction>.Create;
end;

class destructor TChallengeItauModelTransactionList.Destroy;
begin
  FList.Free;
end;

class function TChallengeItauModelTransactionList.GetList: TObjectList<TChallengeItauModelTransaction>;
begin
  Result := FList;
end;

end.
