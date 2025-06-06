program ViaCep;

uses
  Vcl.Forms,
  uCepModel in 'Source\Models\uCepModel.pas',
  uViaCepService in 'Source\Services\uViaCepService.pas',
  uCepService in 'Source\Interfaces\uCepService.pas',
  uCepController in 'Source\Controllers\uCepController.pas',
  uCepDAO in 'Source\DAO\uCepDAO.pas',
  uPrincipal in 'Source\View\uPrincipal.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
