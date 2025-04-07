#include "./createCompsFromSequence.jsx"
#include "./refreshAllFootage.jsx"
#include "./saveProject.jsx"
#include "./createLayers.jsx"
#include "./copyTemplateFootageFX.jsx"
#include "./organizeProject.jsx"
#include "./setExtractor.jsx"
#include "./compDurationOfFootage.jsx"

function Main() {
  CreateCompsFromSequences()
  CreateLayers()
  copyTemplateFootageFX()
  updateAllExtractors()
  RefreshAllFootage()
  matchCompDurationsToFootage()
  OrganizeProject()
  SaveProject()
}

Main();
