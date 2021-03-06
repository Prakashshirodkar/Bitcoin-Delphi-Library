unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls,

  st4makers.BitCoin,

  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMenus,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite;

type

  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action2: TAction;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;

    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    { Private declarations }
    fBlockCount : int64;

    aBCN: TBCN;
    aBlockChainDB: TBlockChainDB;

    procedure RPCReady(Sender: TObject);
    procedure NewBlock(const aBlock: TBlock);
    procedure BlockCount(const aBlockcount: cardinal);
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  end;

var
  Form2: TForm2;

implementation

uses
  BlockDetailViewFormUnit;

{$R *.dfm}

procedure TForm2.Action1Execute(Sender: TObject);
begin
  close;
end;

procedure TForm2.Action2Execute(Sender: TObject);
begin
  with TBlockDetailViewForm.Create(self) do
  begin
    show;
    // BlockHash := GenesisHashBlock;
    BlockHash := LargestTransBlock
  end;
end;

procedure TForm2.BlockCount(const aBlockcount: cardinal);
begin
  fBlockCount := aBlockcount;

  StatusBar1.Panels.Items[0].Text := 'Block count: ' + inttostr(fBlockCount);
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  k, kk: integer;
  aHash0: string;
  aBlock: TBlock;
  // aTx : TTransaction;
begin
  aHash0 := aBCN.GetBlockHash(0);

  Memo1.Lines.Add('Genesis block hash :' + aHash0);

  for k := 1 to 100000 do
  begin
    aBlock := aBCN.GetBlock(aHash0);
    Memo1.Lines.Add(aBlock.ajson);
    Memo1.Lines.Add('Next block: ' + aBlock.nextblockhash);
    Memo1.Lines.Add('');

    for kk := 0 to aBlock.transactions.Count - 1 do
    begin
      Memo1.Lines.Add('  transactions :' + aBlock.transactions[kk]);
      // aTX := aBCN.GetTransaction(ablock.transactions[kk]);
      // Memo1.Lines.Add(datetimetostr(atx.time) );
    end;

    aHash0 := aBlock.nextblockhash;

    Application.ProcessMessages;

    if Memo1.Lines.Count > 1000 then
      Memo1.Lines.Clear;
  end;
end;

constructor TForm2.Create(Owner: TComponent);
begin
  inherited;

  aBCN := TBCN.Create(self);
  aBlockChainDB := TBlockChainDB.Create;

  aBCN.OnReady := RPCReady;
  aBCN.OnNewBlock := NewBlock;
  aBCN.OnBlockCount := BlockCount;
end;

destructor TForm2.Destroy;
begin
  aBCN.Free;

  inherited;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  aBCN.Start;
end;

procedure TForm2.NewBlock(const aBlock: TBlock);
begin
  // new block arrives
 // Memo1.Lines.Add(aBlock.hash);

  StatusBar1.Panels.Items[1].Text := format('Processing block %d - %f%%',
    [aBlock.height, (aBlock.height/fBlockCount)*100]);
end;

procedure TForm2.RPCReady(Sender: TObject);
begin

end;

end.
