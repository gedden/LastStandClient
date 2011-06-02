interface Action;

function actionBegin(int msLate);
function actionEnd();
function actionTick(int dt);

function int GetDuration();
function int GetEffectiveEndTime();
function SetWorldInfo(WorldInfo info);

DefaultProperties
{
}
