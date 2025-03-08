program Challenge_Itau;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Challenge.Itau.Service.Transaction in 'src\service\Challenge.Itau.Service.Transaction.pas',
  Challenge.Itau.Model.Transaction in 'src\model\Challenge.Itau.Model.Transaction.pas',
  Challenge.Itau.Controller.Transaction in 'src\controller\Challenge.Itau.Controller.Transaction.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.Use(Jhonson());

  Challenge.Itau.Controller.Transaction.RegisterRoutes;

  THorse.Listen(9000);
end.
