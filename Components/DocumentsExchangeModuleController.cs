using System.Collections.Generic;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Services.Search;

namespace IgorKarpov.Modules.DocumentsExchangeModule
{ 
    /// <summary> 
    /// The Controller class for DocumentsExchangeModule 
    /// </summary> - 
    public class DocumentsExchangeModuleController : ISearchable
    {

        #region "Public Methods"

        /// ----------------------------------------------------------------------------- 
        /// <summary> 
        /// gets an object from the database 
        /// </summary> 
        /// <remarks> 
        /// </remarks> 
        /// <param name="ModuleId">The Id of the module</param> 
        /// <history> 
        /// </history> 
        /// ----------------------------------------------------------------------------- 
        public List<DocumentsExchangeModuleInfo> GetDocumentsExchangeModulesByUser(int ModuleId, int UserId)
        {

            return CBO.FillCollection<DocumentsExchangeModuleInfo>(DataProvider.Instance().GetDocumentsExchangeModulesByUser(ModuleId, UserId));

        }

        /// ----------------------------------------------------------------------------- 
        /// <summary> 
        /// gets an object from the database 
        /// </summary> 
        /// <remarks> 
        /// </remarks> 
        /// <param name="ModuleId">The Id of the module</param> 
        /// <param name="ItemId">The Id of the item</param> 
        /// <history> 
        /// </history> 
        /// ----------------------------------------------------------------------------- 
        public DocumentsExchangeModuleInfo GetDocumentsExchangeModule(int ModuleId, int ItemId)
        {

            return (DocumentsExchangeModuleInfo)CBO.FillObject(DataProvider.Instance().GetDocumentsExchangeModule(ModuleId, ItemId), typeof(DocumentsExchangeModuleInfo));

        }

        /// ----------------------------------------------------------------------------- 
        /// <summary> 
        /// adds an object to the database 
        /// </summary> 
        /// <remarks> 
        /// </remarks> 
        /// <param name="objDocumentsExchangeModule">The DocumentsExchangeModuleInfo object</param> 
        /// <history> 
        /// </history> 
        /// ----------------------------------------------------------------------------- 
        public void AddDocumentsExchangeModule(DocumentsExchangeModuleInfo objDocumentsExchangeModule)
        {

            if (objDocumentsExchangeModule.Content.Trim() != "")
            {
                DataProvider.Instance().AddDocumentsExchangeModule(objDocumentsExchangeModule.ModuleId, objDocumentsExchangeModule.Content, objDocumentsExchangeModule.CreatedByUser);
            }

        }

        /// ----------------------------------------------------------------------------- 
        /// <summary> 
        /// saves an object to the database 
        /// </summary> 
        /// <remarks> 
        /// </remarks> 
        /// <param name="objDocumentsExchangeModule">The DocumentsExchangeModuleInfo object</param> 
        /// <history> 
        /// </history> 
        /// ----------------------------------------------------------------------------- 
        public void UpdateDocumentsExchangeModule(DocumentsExchangeModuleInfo objDocumentsExchangeModule)
        {

            if (objDocumentsExchangeModule.Content.Trim() != "")
            {
                DataProvider.Instance().UpdateDocumentsExchangeModule(objDocumentsExchangeModule.ModuleId, objDocumentsExchangeModule.ItemId, objDocumentsExchangeModule.Content, objDocumentsExchangeModule.CreatedByUser);
            }

        }

        /// ----------------------------------------------------------------------------- 
        /// <summary> 
        /// deletes an object from the database 
        /// </summary> 
        /// <remarks> 
        /// </remarks> 
        /// <param name="ModuleId">The Id of the module</param> 
        /// <param name="ItemId">The Id of the item</param> 
        /// <history> 
        /// </history> 
        /// ----------------------------------------------------------------------------- 
        public void DeleteDocumentsExchangeModule(int ModuleId, int ItemId)
        {

            DataProvider.Instance().DeleteDocumentsExchangeModule(ModuleId, ItemId);

        }

        #endregion

        #region "Optional Interfaces"

        /// ----------------------------------------------------------------------------- 
        /// <summary> 
        /// GetSearchItems implements the ISearchable Interface 
        /// </summary> 
        /// <remarks> 
        /// </remarks> 
        /// <param name="ModInfo">The ModuleInfo for the module to be Indexed</param> 
        /// <history> 
        /// </history> 
        /// ----------------------------------------------------------------------------- 
        public DotNetNuke.Services.Search.SearchItemInfoCollection GetSearchItems(ModuleInfo ModInfo)
        {

            SearchItemInfoCollection SearchItemCollection = new SearchItemInfoCollection();

            List<DocumentsExchangeModuleInfo> colDocumentsExchangeModules = GetDocumentsExchangeModulesByUser(ModInfo.ModuleID, ModInfo.CreatedByUserID);
            foreach (DocumentsExchangeModuleInfo objDocumentsExchangeModule in colDocumentsExchangeModules)
            {
                SearchItemInfo searchItem = new SearchItemInfo(ModInfo.ModuleTitle, objDocumentsExchangeModule.Content, objDocumentsExchangeModule.CreatedByUser, objDocumentsExchangeModule.CreatedDate, ModInfo.ModuleID, objDocumentsExchangeModule.ItemId.ToString(), objDocumentsExchangeModule.Content, "ItemId=" + objDocumentsExchangeModule.ItemId.ToString());
                SearchItemCollection.Add(searchItem);
            }

            return SearchItemCollection;

        }


        #endregion

    }
}