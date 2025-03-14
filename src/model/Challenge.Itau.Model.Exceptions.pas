unit Challenge.Itau.Model.Exceptions;

interface

uses
  System.SysUtils;

type
  EValidationError = class(Exception)
  private
  public
    constructor Create(const AErrorMessage: string);
  end;

  EJSONValidationError = class(Exception)
  private
  public
    constructor Create(const AErrorMessage: string);
  end;

implementation

{ EValidationError }

constructor EValidationError.Create(const AErrorMessage: string);
begin
  inherited Create(AErrorMessage);
end;

{ EJSONValidationError }

constructor EJSONValidationError.Create(const AErrorMessage: string);
begin
  inherited Create(AErrorMessage);
end;

end.
