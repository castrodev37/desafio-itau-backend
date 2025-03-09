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
      on E: EValidationError do
      begin
        Writeln('Erro de valida��o: ', E.Message);
        Res
          .Send(Format('{"status": "error", "message": "%s"}', [E.Message])
          ).Status(THTTPStatus.UnprocessableEntity);
      end;
      on E: EJSONValidationError do
      begin
        Writeln('Erro de valida��o do JSON: ', E.Message);
        Res
          .Send(Format('{"status": "error", "message": "%s"}', [E.Message])
          ).Status(THTTPStatus.BadRequest);
      end;
      on E: Exception do
      begin
        Writeln('Erro interno: ', E.Message);
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('status', 'error')
            .AddPair('message', E.Message)
        ).Status(THTTPStatus.InternalServerError);
      end;
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
      on E: EValidationError do
      begin
        Writeln('Erro de valida��o: ', E.Message);
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('status', 'error')
            .AddPair('message', E.Message)
        ).Status(THTTPStatus.UnprocessableEntity);
      end;
      on E: EJSONValidationError do
      begin
        Writeln('Erro de valida��o do JSON: ', E.Message);
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('status', 'error')
            .AddPair('message', E.Message)
        ).Status(THTTPStatus.BadRequest);
      end;
      on E: Exception do
      begin
        Writeln('Erro interno: ', E.Message);
        Res.Send<TJSONObject>(
          TJSONObject.Create
            .AddPair('status', 'error')
            .AddPair('message', E.Message)
        ).Status(THTTPStatus.InternalServerError);
      end;
    end;
  finally
    LService.Free;
  end;
end;

procedure RegisterRoutes;
begin
  THorse.Post('/transacao', InsertTransaction);
  THorse.Delete('/transacao', DeleteTransaction);
end;

end.
