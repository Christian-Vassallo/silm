//Get the number of seconds passed since the decay variable is set
int SecondsPassed(object oWho, string sPref);

void SetLocalDecay(object oWho, string sVarname, int iValue, int iDecPerHour);

int GetLocalDecay(object oWho, string sVarname);

//Get the number of ticks the variable goes down per game hour
int GetLocalDecrate(object oWho, string sVarname);

