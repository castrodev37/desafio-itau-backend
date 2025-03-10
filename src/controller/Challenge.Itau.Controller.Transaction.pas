unit Challenge.Itau.Controller.Transaction;

interface

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Challenge.Itau.Service.Transaction,
  Challenge.Itau.Model.Exceptions;

procedure RegisterRoutes;

implementation

procedure HandleException(const Req: THorseRequest; const Res: THorseResponse; const E: Exception);
begin
  if E is EValidationError then
  begin
    Writeln('Erro de validação: ', E.Message);
    Res
      .Send(Format('{"status": "error", "message": "%s"}', [E.Message])
      ).Status(THTTPStatus.UnprocessableEntity)
  end
  else if E is EJSONValidationError then
  begin
    Writeln('Erro de validação do JSON: ', E.Message);
    Res
      .Send(Format('{"status": "error", "message": "%s"}', [E.Message])
      ).Status(THTTPStatus.BadRequest)
  end
  else
  begin
    Writeln('Erro interno: ', E.Message);
    Res
      .Send(Format('{"status": "error", "message": "%s"}', [E.Message])
      ).Status(THTTPStatus.InternalServerError);
  end;
end;

procedure InsertTransaction(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TChallengeItauServiceTransaction;
begin
  LService := TChallengeItauServiceTransaction.Create;
  try
    try
      LService.Insert(Req.Body<TJSONObject>);
      Res.Status(THTTPSTatus.Created);
    except
      on E: Exception do
        HandleException(Req, Res, E);
    end;
  finally
    LService.Free;
  end;
end;

procedure DeleteTransaction(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TChallengeItauServiceTransaction;
begin
  LService := TChallengeItauServiceTransaction.Create;
  try
    try
      LService.Delete;
      Res.Status(THTTPSTatus.OK);
    except
      on E: Exception do
        HandleException(Req, Res, E);
    end;
  finally
    LService.Free;
  end;
end;

procedure TransactionStatistics(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TChallengeItauServiceTransaction;
begin
  LService := TChallengeItauServiceTransaction.Create;
  try
    try
      Res
        .Send<TJSONObject>(LService.Statistics)
        .Status(THTTPSTatus.OK);
    except
      on E: Exception do
        HandleException(Req, Res, E);
    end;
  finally
    LService.Free;
  end;
end;

procedure RegisterRoutes;
begin
  THorse.Post('/transacao', InsertTransaction);
  THorse.Delete('/transacao', DeleteTransaction);
  THorse.Get('/estatistica', TransactionStatistics);
end;

end.
