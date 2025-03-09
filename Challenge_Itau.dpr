program Challenge_Itau;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Challenge.Itau.Service.Transaction in 'src\service\Challenge.Itau.Service.Transaction.pas',
  Challenge.Itau.Model.Transaction in 'src\model\Challenge.Itau.Model.Transaction.pas',
  Challenge.Itau.Controller.Transaction in 'src\controller\Challenge.Itau.Controller.Transaction.pas',
  Challenge.Itau.Model.Exceptions in 'src\model\Challenge.Itau.Model.Exceptions.pas',
  Challenge.Itau.Model.TransactionList in 'src\model\Challenge.Itau.Model.TransactionList.pas';

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    THorse
      .Use(Jhonson())
      .Use(CORS);

    Challenge.Itau.Controller.Transaction.RegisterRoutes;
  except
    on E: Exception do
      Writeln('Erro: ', E.Message);
  end;

  THorse.Listen(9000,
    procedure
    begin
      Writeln('Server is runnig on http://localhost:9000');
    end);
end.
