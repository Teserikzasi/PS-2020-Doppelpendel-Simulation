/*
@@ABOUT@@
*/

#define S_FUNCTION_NAME @@SFCTNAME@@
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include <math.h>

#define SYS_NSTATES		@@NSTATES@@
#define SYS_NINPUTS		@@NINPUTS@@
#define SYS_BDIRECTFEEDTRHOUGH	@@BDIRECTFEEDTHROUGH@@
#define SYS_NOUTPUTS	@@NOUTPUTS@@
#define SYS_BPARAM		@@PARAMPARAM@@
#define SYS_NPARAMS		@@NPARAMS@@
const char* const g_aszParamFields[] = {@@PARAMFIELDS@@};


#if (SYS_BPARAM)
	#define N_PARAMS		3
		
	#define PID_SYSPARAM	0
	#define PID_X0			1
	#define PID_SHOWSTATES	2
		
	#define PPTR_SYSPARAM(S) ssGetSFcnParam(S, PID_SYSPARAM)
	#define PVPTR_SYSPARAM(S) mxGetPr(PPTR_SYSPARAM(S))
#else
	#define N_PARAMS		2
		
	#define PID_X0			0
	#define PID_SHOWSTATES	1

	#define PPTR_SYSPARAM(S) NULL
	#define PVPTR_SYSPARAM(S) NULL
#endif

#define PPTR_X0(S) ssGetSFcnParam(S, PID_X0)
#define PVPTR_X0(S) mxGetPr(PPTR_X0(S))
		
#define PPTR_SHOWSTATES(S) ssGetSFcnParam(S, PID_SHOWSTATES)
#define PVAL_SHOWSTATES(S) *mxGetPr(PPTR_SHOWSTATES(S))

#define INVPTR_U(S) ssGetInputPortSignal(S, 0)
		
#define OUTVPTR_Y(S) ssGetOutputPortSignal(S, 0)
#define OUTVPTR_X(S) ssGetOutputPortSignal(S, 1)


// Arbeitsvektoren
#define N_PWORKS 1
#define PWID_PARAMVALS	0
#define PWPTR_PARAMVALS(S) ssGetPWorkValue(S, PWID_PARAMVALS)
		
		
static void mdlCheckParameters(SimStruct *S);
static boolean_T readParamValues(
						const mxArray* pParamStruct, real_T* padParamVals);

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
	uint_T p;
	
    ssSetNumSFcnParams(S, N_PARAMS);  /* Number of expected parameters */

#if defined(MATLAB_MEX_FILE)
	if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S))
	{
		mdlCheckParameters(S);
		if (ssGetErrorStatus(S) != NULL)
			return;
	}
	else // -> if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
	{
		return;
	}

#endif

	for (p = 0; p < N_PARAMS; p ++)
	{
		ssSetSFcnParamTunable(S, p, SS_PRM_NOT_TUNABLE);
	}


    ssSetNumContStates(S, SYS_NSTATES);
    ssSetNumDiscStates(S, 0);

	if (SYS_NINPUTS == 0)
	{
		if (!ssSetNumInputPorts(S, 0))
			return;
	}
	else
	{
		if (!ssSetNumInputPorts(S, 1))
			return;

		ssSetInputPortMatrixDimensions(S, 0, SYS_NINPUTS, 1);
		ssSetInputPortDirectFeedThrough(S, 0, SYS_BDIRECTFEEDTRHOUGH);
		ssSetInputPortRequiredContiguous(S, 0, 1);
	}
	
	if (PVAL_SHOWSTATES(S))
	{
	    if (!ssSetNumOutputPorts(S, 2))
			return;
	}
	else
	{
	    if (!ssSetNumOutputPorts(S, 1))
			return;
	}
	
    ssSetOutputPortMatrixDimensions(S, 0, SYS_NOUTPUTS, 1);

	if (PVAL_SHOWSTATES(S))
	{
		ssSetOutputPortMatrixDimensions(S, 1, SYS_NSTATES, 1);
	}

	ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, N_PWORKS);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    //ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);
	// (Auskommentiert, damit auch unter 2007b kompiliert)

    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
    //ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    S-function is comprised of only continuous sample time elements
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetModelReferenceSampleTimeDefaultInheritance(S);
}


#define MDL_CHECK_PARAMETERS   /* Change to #undef to remove function */
#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)
  /* Function: mdlCheckParameters =============================================
   */
static void mdlCheckParameters(SimStruct *S)
{
	if (SYS_BPARAM)
	{
		if ( mxIsStruct(PPTR_SYSPARAM(S)) )
		{
			if ( !readParamValues(PPTR_SYSPARAM(S), NULL) )
				ssSetErrorStatus(S, "Parameterstruktur fehlerhaft!");
		}
		else if ( mxIsDouble(PPTR_SYSPARAM(S)) )
		{
			if ( mxGetNumberOfElements(PPTR_SYSPARAM(S)) != SYS_NPARAMS )
				ssSetErrorStatus(S, "Parametervektor hat falsche Länge!");
		}
		else
		{
			ssSetErrorStatus(S, "Parametervariable muss Struktur oder Vektor von double-Werten sein!");
		}
	}
	

		
	if ( !mxIsDouble(PPTR_X0(S)) )
		ssSetErrorStatus(S, "x0 muss vom Typ double sein!");

	if ( ( mxGetNumberOfElements(PPTR_X0(S)) != 1 ) &&
			( mxGetNumberOfElements(PPTR_X0(S)) != SYS_NSTATES ) )
		ssSetErrorStatus(S, "x0 hat falsche Länge!");

	
	if ( !mxIsDouble(PPTR_SHOWSTATES(S)) || 
			(mxGetNumberOfElements(PPTR_SHOWSTATES(S)) != 1) ||
			!((PVAL_SHOWSTATES(S) == 0) || (PVAL_SHOWSTATES(S) == 1)) )
	{
		ssSetErrorStatus(S, "ShowStates muss Skalar vom Typ double sein und den Wert 0 oder 1 annehmen!");
	}
	
	return;
}
#endif /* MDL_CHECK_PARAMETERS */



#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
/* Function: mdlStart =======================================================
* Abstract:
*    This function is called once at start of model execution. If you
*    have states that should be initialized once, this is the place
*    to do it.
*/
static void mdlStart(SimStruct *S)
{
	real_T* padParamVals;
	real_T* padParamParam;
	uint_T p;
	
	if (SYS_NPARAMS == 0)
	{
		padParamVals = NULL;
	}
	else
	{
		padParamVals = malloc(SYS_NPARAMS * sizeof(real_T));
		
		if ( mxIsStruct(PPTR_SYSPARAM(S)) )
		{
			readParamValues(PPTR_SYSPARAM(S), padParamVals);
		}
		else
		{
			padParamParam = PVPTR_SYSPARAM(S);
			
			for (p = 0; p < SYS_NPARAMS; p++)
				padParamVals[p] = padParamParam[p];
		}
	}
	
	ssSetPWorkValue(S, PWID_PARAMVALS, padParamVals);

	return;
}
#endif /*  MDL_START */



#define MDL_INITIALIZE_CONDITIONS
/* Function: mdlInitializeConditions ========================================
 * Abstract:
 *    Initialize continuous states to zero
 */
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *x = ssGetContStates(S);
    real_T *x0 = PVPTR_X0(S);
    int_T  k;
	boolean_T bSingleInitValue;
	
	bSingleInitValue = ( mxGetNumberOfElements(PPTR_X0(S)) == 1 );

    for (k = 0; k < SYS_NSTATES; k++)
	{ 
		if ( bSingleInitValue )
			*x++ = *x0;
		else
			*x++ = *x0++;
    }
	
	return;
}



/* Function: mdlOutputs =======================================================
*/
static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T* y = OUTVPTR_Y(S);
    real_T* yx = NULL;
	const real_T* x = ssGetContStates(S);
	const real_T* u = NULL;
	const real_T* p = NULL;
	
	int_T k;
	
    UNUSED_ARG(tid); /* not used in single tasking mode */

	if ( (SYS_NINPUTS > 0) && (SYS_BDIRECTFEEDTRHOUGH) )
		u = INVPTR_U(S);

	if (SYS_BPARAM)
		p = (real_T*)PWPTR_PARAMVALS(S);
	
@@OUTPUTEQ@@
			

	if (PVAL_SHOWSTATES(S))
	{
		yx = OUTVPTR_X(S);
		
		for (k = 0; k < SYS_NSTATES; k++)
			*yx++ = *x++;
	}
}



#define MDL_DERIVATIVES
/* Function: mdlDerivatives =================================================
 * Abstract:
 *      Calculate state-space derivatives
 */
static void mdlDerivatives(SimStruct *S)
{
    real_T* dx = ssGetdX(S);
    const real_T* x = ssGetContStates(S);
    const real_T* u = NULL;
	const real_T* p = NULL;
	
	if (SYS_NINPUTS > 0)
		u = INVPTR_U(S);

	if (SYS_BPARAM)
		p = (real_T*)PWPTR_PARAMVALS(S);
	
@@STATEEQ@@
		
}



/* Function: mdlTerminate =====================================================
 */
static void mdlTerminate(SimStruct *S)
{
	real_T* padParamVals;
	
	padParamVals = (real_T*)PWPTR_PARAMVALS(S);
	
	if (padParamVals != NULL)
		free(padParamVals);

	return;
}



static boolean_T readParamValues(const mxArray* pParamStruct, real_T* padParamVals)
{
	boolean_T bOk = true;
	const mxArray* pField; 
	uint_T p;
	
	for (p = 0; p < SYS_NPARAMS; p++)
	{
		pField = mxGetField(pParamStruct, 0, g_aszParamFields[p]);
		
		if (pField == NULL)
		{
			ssPrintf("Feld '%s' nicht in Parameterstruktur enthalten!\n", 
													g_aszParamFields[p]);
			bOk = false;
			continue;
		}
		
		if ( !mxIsDouble(pField) || (mxGetNumberOfElements(pField) != 1) )
		{
			ssPrintf("Feld '%s' in Parameterstruktur ist kein skalarer Double-Wert!\n", 
													g_aszParamFields[p]);
			bOk = false;
			continue;
		}

		if (padParamVals != NULL)
		{
			padParamVals[p] = *mxGetPr(pField);
		}
	}
	
	return bOk;
}


#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
