{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
{                                       R�gys Silveira                         }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 24/10/2008: Primeira Versao
|*    Daniel Simoes de Almeida
******************************************************************************}

{$I ACBr.inc}

unit ACBrCNIEE;

interface

uses
  Contnrs,  SysUtils, Variants, Classes,
  ACBrUtil, ACBrSocket;

const
  CURL_Download_Tabela_CNIEE = 'http://www.fazenda.mg.gov.br/empresas/ecf/files/Tabela_CNIEE.bin' ;

type
  EACBrCNIEE = class(Exception);

  TACBrCNIEEExporta = (exCSV, exDSV);

  TRegistro = packed record
    Marca        : string[2];
    Modelo       : string[2];
    Versao       : string[2];
    Tipo         : string[10];
    MarcaDescr   : string[30];
    ModeloDescr  : string[30];
    VersaoSB     : string[20];
    QtLacreSL    : Integer;
    QTLacreFab   : Integer;
    MFD          : string[3];
    LacreMFD     : string[3];
    AtoAprovacao : string[25];
    AtoRegistroMG: string[25];
    FormatoNumero: string[20];
  end;

  TACBrCNIEERegistro = class
  private
    FDescrModelo: String;
    FCodCodModelo: String;
    FAtoAprovacao: String;
    FVersao: String;
    FQtLacresFab: Integer;
    FQtLacresSL: Integer;
    FTemLacreMFD: String;
    FDescrMarca: String;
    FAtoRegistro: String;
    FTemMFD: String;
    FCodMarca: String;
    FCodCodVersao: String;
    FFormatoNumFabricacao: String;
    FTipoECF: String;
  public
    property CodMarca: String read FCodMarca write FCodMarca;
    property CodCodModelo: String read FCodCodModelo write FCodCodModelo;
    property CodCodVersao: String read FCodCodVersao write FCodCodVersao;
    property TipoECF: String read FTipoECF write FTipoECF;
    property DescrMarca: String read FDescrMarca write FDescrMarca;
    property DescrModelo: String read FDescrModelo write FDescrModelo;
    property Versao: String read FVersao write FVersao;
    property TemMFD: String read FTemMFD write FTemMFD;
    property TemLacreMFD: String read FTemLacreMFD write FTemLacreMFD;
    property AtoAprovacao: String read FAtoAprovacao write FAtoAprovacao;
    property AtoRegistro: String read FAtoRegistro write FAtoRegistro;
    property FormatoNumFabricacao: String read FFormatoNumFabricacao write FFormatoNumFabricacao;
    property QtLacresSL: Integer read FQtLacresSL write FQtLacresSL;
    property QtLacresFab: Integer read FQtLacresFab write FQtLacresFab;
  end;

  TACBrCNIEERegistros = class(TObjectList)
  private
    function GetItem(Index: integer): TACBrCNIEERegistro;
    procedure SetItem(Index: integer; const Value: TACBrCNIEERegistro);
  public
    function New: TACBrCNIEERegistro;
    property Items[Index: integer]: TACBrCNIEERegistro read GetItem write SetItem; default;
  end;

  TACBrCNIEE = class(TACBrHTTP)
  private
    FArquivo: String;
    FURLDownload: String;
    FCadastros: TACBrCNIEERegistros;
    procedure ExportarCSV(const AArquivo: String);
    procedure ExportarDSV(const AArquivo: String);
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    function DownloadTabela: Boolean;
    function AbrirTabela: Boolean;
    procedure Exportar(const AArquivo: String; ATipo: TACBrCNIEEExporta);

    property Cadastros: TACBrCNIEERegistros read FCadastros;
    
  published
    property Arquivo: String read FArquivo write FArquivo;
    property URLDownload: String read FURLDownload write FURLDownload;
  end;

implementation

{ TACBrCNIEERegistros }

function TACBrCNIEERegistros.GetItem(Index: integer): TACBrCNIEERegistro;
begin
  Result := TACBrCNIEERegistro(inherited Items[Index]);
end;

function TACBrCNIEERegistros.New: TACBrCNIEERegistro;
begin
  Result := TACBrCNIEERegistro.Create;
  Add(Result);
end;

procedure TACBrCNIEERegistros.SetItem(Index: integer;
  const Value: TACBrCNIEERegistro);
begin
  Put(Index, Value);
end;

{ TACBrCNIEE }

constructor TACBrCNIEE.Create(AOwner: TComponent);
begin
  inherited;

  FCadastros   := TACBrCNIEERegistros.Create;
  FURLDownload := CURL_Download_Tabela_CNIEE;
end;

destructor TACBrCNIEE.Destroy;
begin
  FCadastros.Free;
  inherited;
end;


function TACBrCNIEE.DownloadTabela: Boolean;
begin
  if Trim(FURLDownload) = '' then
    raise EACBrCNIEE.Create('URL de Download n�o informada.');

  if Trim(FArquivo) = '' then
    raise EACBrCNIEE.Create('Nome do arquivo em disco n�o especificado.');

  try
     HTTPGet( FURLDownload );
     HTTPSend.Document.Seek(0, soFromBeginning);
     HTTPSend.Document.SaveToFile( FArquivo );
     Result := True;
  except
     Result := False ;
  end ;
end;

function TACBrCNIEE.AbrirTabela: Boolean;
var
  F: file of TRegistro;
  Registro: TRegistro;
  FileName: String;
begin
  FileName := Trim(FArquivo);

  if FileName = '' then
    raise Exception.Create('Nome do arquivo em Disco n�o especificado.');

  if not FileExists(FileName) then
    raise Exception.Create('Arquivo n�o encontrado:' + sLineBreak + FileName);

  FCadastros.Clear;
  AssignFile(F, Filename);
  try
    Reset(F);
    while not Eof(F) do
    begin
      Read(F, Registro);

      with FCadastros.New do
      begin
        CodMarca             := Trim(string(Registro.Marca));
        CodCodModelo         := Trim(string(Registro.Modelo));
        CodCodVersao         := Trim(string(Registro.Versao));
        TipoECF              := Trim(string(Registro.Tipo));
        DescrMarca           := Trim(string(Registro.MarcaDescr));
        DescrModelo          := Trim(string(Registro.ModeloDescr));
        Versao               := Trim(string(Registro.VersaoSB));
        QtLacresSL           := Registro.QtLacreSL;
        QtLacresFab          := Registro.QTLacreFab;
        TemMFD               := Trim(string(Registro.MFD));
        TemLacreMFD          := Trim(string(Registro.LacreMFD));
        AtoAprovacao         := Trim(string(Registro.AtoAprovacao));
        AtoRegistro          := Trim(string(Registro.AtoRegistroMG));
        FormatoNumFabricacao := Trim(string(Registro.FormatoNumero));
      end;
    end;
    Result := True;
  finally
    CloseFile(F);
  end;
end;

procedure TACBrCNIEE.Exportar(const AArquivo: String; ATipo: TACBrCNIEEExporta);
begin
  if Cadastros.Count <= 0 then
    Self.AbrirTabela;

  case ATipo of
    exCSV: ExportarCSV(AArquivo);
    exDSV: ExportarDSV(AArquivo);
  end;
end;

procedure TACBrCNIEE.ExportarCSV(const AArquivo: String);
var
  I: Integer;
  Texto: String;
begin
  Texto := '';
  for I := 0 to Cadastros.Count - 1 do
  begin
    Texto := Texto +
      Cadastros[I].CodMarca + ',' +
      Cadastros[I].CodCodModelo + ',' +
      Cadastros[I].CodCodVersao + ',' +
      Cadastros[I].TipoECF + ',' +
      Cadastros[I].DescrMarca + ',' +
      Cadastros[I].DescrModelo + ',' +
      Cadastros[I].Versao + ',' +
      IntToStr(Cadastros[I].QtLacresSL) + ',' +
      IntToStr(Cadastros[I].QtLacresFab) + ',' +
      Cadastros[I].TemMFD + ',' +
      Cadastros[I].TemLacreMFD + ',' +
      Cadastros[I].AtoAprovacao + ',' +
      Cadastros[I].AtoRegistro + ',' +
      Cadastros[I].FormatoNumFabricacao + ',' +
      sLineBreak;
  end;

  if Trim(Texto) <> '' then
    WriteToTXT(AnsiString(AArquivo), AnsiString(Texto), False, False);
end;

procedure TACBrCNIEE.ExportarDSV(const AArquivo: String);
var
  I: Integer;
  Texto: String;

  function AddAspasDuplas(const ATexto: String): String;
  begin
    Result := '"' + ATexto + '"';
  end;

begin
  Texto := '';
  for I := 0 to Cadastros.Count - 1 do
  begin
    Texto := Texto +
      AddAspasDuplas(Cadastros[I].CodMarca) + ',' +
      AddAspasDuplas(Cadastros[I].CodCodModelo) + ',' +
      AddAspasDuplas(Cadastros[I].CodCodVersao) + ',' +
      AddAspasDuplas(Cadastros[I].TipoECF) + ',' +
      AddAspasDuplas(Cadastros[I].DescrMarca) + ',' +
      AddAspasDuplas(Cadastros[I].DescrModelo) + ',' +
      AddAspasDuplas(Cadastros[I].Versao) + ',' +
      AddAspasDuplas(IntToStr(Cadastros[I].QtLacresSL)) + ',' +
      AddAspasDuplas(IntToStr(Cadastros[I].QtLacresFab)) + ',' +
      AddAspasDuplas(Cadastros[I].TemMFD) + ',' +
      AddAspasDuplas(Cadastros[I].TemLacreMFD) + ',' +
      AddAspasDuplas(Cadastros[I].AtoAprovacao) + ',' +
      AddAspasDuplas(Cadastros[I].AtoRegistro) + ',' +
      AddAspasDuplas(Cadastros[I].FormatoNumFabricacao) + ',' +
      sLineBreak;
  end;

  if Trim(Texto) <> '' then
    WriteToTXT(AnsiString(AArquivo), AnsiString(Texto), False, False);
end;

end.
