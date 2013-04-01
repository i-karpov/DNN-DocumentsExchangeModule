<%@ Control Language="C#" Inherits="IgorKarpov.Modules.DocumentsExchangeModule.ViewDocumentsExchangeModule"
    AutoEventWireup="true" CodeBehind="ViewDocumentsExchangeModule.ascx.cs" %>




<asp:MultiView ID="multiView" runat="server" ActiveViewIndex="0">
    <asp:View ID="filesPage" runat="server">
        <asp:DataList ID="lstContent" DataKeyField="ItemID" runat="server" CellPadding="4"
            OnItemDataBound="lstContent_ItemDataBound" BackColor="White" Width="100%">
            <ItemTemplate>
                <table cellpadding="4" style="width: 100%">
                    <tr>
                        <td valign="top" width="40%" align="left">

                                        <asp:Label ID="lblContent" runat="server" Text="Content" CssClass="Normal" />
                        </td>
                        <td valign="top" width="20%" align="left">
                                        <asp:Label ID="createdByLable" runat="server" Text="Created By"></asp:Label>
                        </td>
                        <td valign="top" width="20%" align="left">
                                        <asp:Label ID="creationDateLabel" runat="server" Text="Creation Date"></asp:Label>
                        </td>
                        <td valign="top" width="20%" align="right">

                                        <asp:HyperLink ID="HyperLink1" NavigateUrl='<%# EditUrl("ItemID",DataBinder.Eval(Container.DataItem,"ItemID").ToString()) %>'
                                            Visible="<%# IsEditable %>" runat="server">
                                            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/edit.gif" AlternateText="Edit"
                                                Visible="<%#IsEditable%>" resourcekey="Edit" />
                                        </asp:HyperLink>
                                        <asp:Button ID="deleteItemButton" runat="server" Text="X" />

                        </td>
                    </tr>
                </table>
            </ItemTemplate>
        </asp:DataList>
        <asp:Button ID="showUploadPageButton" runat="server" OnClick="showUploadPageButton_Click" Text="Upload file" />
    </asp:View>

    <asp:View ID="uploadFilePage" runat="server">
        <asp:FileUpload ID="fileUploader" runat="server" />
        <asp:Button ID="uploadButton" runat="server" CssClass="myButton" Text="Upload" OnClick="uploadButton_Click" />
        <asp:Panel ID="Panel1" runat="server">
            <asp:Button ID="showFilesPageButton" runat="server" OnClick="showFilesPageButton_Click" Text="Back" />
        </asp:Panel>
    </asp:View>
</asp:MultiView>

<p>
    &nbsp;
</p>

