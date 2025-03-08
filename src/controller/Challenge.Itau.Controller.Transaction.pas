unit Challenge.Itau.Controller.Transaction;

interface

procedure RegisterRoutes;

implementation

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Challenge.Itau.Service.Transaction;

procedure InsertTransaction(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TChallengeItauServiceTransaction;
begin
  LService := TChallengeItauServiceTransaction.Create;
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>)).Status(THTTPSTatus.Created);
  finally
    LService.Free;
  end;
end;

procedure RegisterRoutes;
begin
  THorse.Post('/transacao', InsertTransaction);
end;

end.
