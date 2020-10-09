% Level 2 m-s-function : 'SchlittenPendelFunc.m'
%
%<<<<<<< tobi-Regelung
% Created by sys2sfct at 09-Oct-2020 15:03:26 from the following system:
%=======
% Created by sys2sfct at 09-Oct-2020 10:40:57 from the following system:
%>>>>>>> master
% Name        : SchlittenPendel NLZSR (F)
% Description : Nichtlineare Zustandsraumdarstellung des Schlitten-Doppelpendel-Systems (Eingang: F) (Parameter: Doppelpendel rtm (Ribeiro))
%
% System type : NLTI
% State eq.   : dx=f(x,u)
% Output eq.  : y=h(x)
%
% Nb. Inputs  : 1
% Nb. States  : 6
% Nb. Outputs : 3
%
%     u = [ F ]'
%     x = [ x0, x0_p, phi1, phi1_p, phi2, phi2_p ]'
%     y = [ x0, phi1, phi2 ]'
%
% Nb. Params  : 0
%
%

function SchlittenPendelFunc(block)

  setup(block);
  
end % function Systemgleichung

function setup(block)

    %% Register number of dialog parameters
    block.NumDialogPrms = 2 + 0;

    %% Set block sample time to continuous
    block.SampleTimes = [0 0];

    %stParam = block.DialogPrm(0).Data;
    %x0 = block.DialogPrm(1+0).Data;
    bShowStates = block.DialogPrm(2+0).Data;
    
    % Dimensionen feststellen, wenn nicht explizit gegeben
    
    block.NumContStates = 6;
    
    %% Register number of input and output ports
    
    nInputs = 1;
    
    if (nInputs == 0)
        block.NumInputPorts = 0;
    else
        block.NumInputPorts = 1;
        block.InputPort(1).Dimensions = [nInputs, 1];
        block.InputPort(1).DirectFeedthrough = false;
    end

    
    if (bShowStates)
        block.NumOutputPorts = 2;
    else
        block.NumOutputPorts = 1;
    end
    
    block.OutputPort(1).Dimensions = [3, 1];
    
    if (bShowStates)
        block.OutputPort(2).Dimensions = [6, 1];
    end



    %% Register methods
    block.RegBlockMethod('SetInputPortSamplingMode',    @SetInputPortSMode);
    block.RegBlockMethod('Outputs',                        @Output);  
    block.RegBlockMethod('InitializeConditions',        @InitConditions);
    block.RegBlockMethod('Derivatives',                    @Derivative);  

end % function setup


function SetInputPortSMode(block, idx, fd)

    block.InputPort(idx).SamplingMode = fd;
    
    if (idx == 1)
        for o = 1:block.NumOutputPorts
            block.OutputPort(o).SamplingMode = fd;
        end % for o
    end
    
end % function SetInputPortSMode


function InitConditions(block)  

    % Initialize Dwork
    x0 = block.DialogPrm(1+0).Data;
    
    if ( (length(x0) == 1) && (x0 == 0) )
        x0 = zeros(block.NumContStates, 1);
    end

    block.ContStates.Data = x0;
  
end % function InitConditions


function Output(block)

    bShowStates = block.DialogPrm(2+0).Data;
    
    x = block.ContStates.Data;
    t = block.CurrentTime;
    
    if (0 > 0)
        p = block.DialogPrm(0).Data;
    end


    bDirectFeedthrough = false;
    if (bDirectFeedthrough)
        u = block.InputPort(1).Data;
    end

    y = [x(1); x(3); x(5)];
    
    block.OutputPort(1).Data = y;
    
    if bShowStates
        block.OutputPort(2).Data = x;
    end

end % function Output


function Derivative(block)

    nInputs = 1;
    if (nInputs > 0)
        u = block.InputPort(1).Data;
    end
    
    if (0 > 0)
        p = block.DialogPrm(0).Data;
    end

    x = block.ContStates.Data;
    t = block.CurrentTime;
    
    dx = [x(2); ((3820233196762960315796634201740252029412216470727*x(2))/324518553658426726783156020576256000000000000000000 - (224719599809585900929213776572956001730130380631*u(1))/324518553658426726783156020576256000000000000000000 - (642592285282270361818149385306967559138097422974565837*sin(2*x(3)))/324518553658426726783156020576256000000000000000000000000 + (49187537984685725121258703544507590886611535722155273*sin(2*x(5)))/649037107316853453566312041152512000000000000000000000000 + (301798422544273864947934101937479910323565101187433*tanh(100*x(2)))/32451855365842672678315602057625600000000000000000000 - (7084165337050448386397902949267202897129873927*tanh(100*x(2))*cos(2*x(3) - 2*x(5)))/3245185536584267267831560205762560000000000000000 + (16826276370731047778730802302526219228585273498704579271*x(4)^2*sin(x(3)))/162259276829213363391578010288128000000000000000000000000000 + (1230604482947189756657804979340204530607210607221794861785011041603*x(6)^2*sin(x(5)))/116920130986472233456294786617302641572474603438080000000000000000000000 + (5274881114706216222187567348672526356760889*u(1)*cos(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000 - (89672978950005675777188644927432948064935113*x(2)*cos(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000 + (578300209597244220100067150914127431314785733*x(4)*cos(2*x(3) - x(5)))/830767497365572420564879412675215360000000000000000 - (578300209597244220100067150914127431314785733*x(6)*cos(2*x(3) - x(5)))/830767497365572420564879412675215360000000000000000 + (370112134142236292064122364737255314561171833*cos(2*x(3) - x(5))*tanh(100*x(4) - 100*x(6)))/1661534994731144841129758825350430720000000000000000 + (7069768456514462020486724974287023766577193207771553*x(4)^2*sin(x(3) - 2*x(5)))/3245185536584267267831560205762560000000000000000000000000 + (2342699081422418128104221794017655822538567993*tanh(100*x(4))*cos(x(3)))/16225927682921336339157801028812800000000000000000 + (1999354276311718354453660023416249858322082150799198619628687099*x(4)*cos(x(3)))/93536104789177786765035829293842113257979682750464000000000000000000 - (49738438967149291299586786431570787558591130949*x(4)*cos(x(5)))/83076749736557242056487941267521536000000000000000000 - (22892794726883704568057029830199235072738866251482838496367*x(6)*cos(x(3)))/29931553532536891764811465374029476242553498480148480000000000000 + (49738438967149291299586786431570787558591130949*x(6)*cos(x(5)))/83076749736557242056487941267521536000000000000000000 + (15705812664355393818581061527217404107500464265838481201324192751*x(6)^2*sin(2*x(3) - x(5)))/1169201309864722334562947866173026415724746034380800000000000000000000 - (10063425672737391232400394445339784326019001*cos(x(3) - 2*x(5))*tanh(100*x(4)))/324518553658426726783156020576256000000000000000 + (14651388625205570575199758359369424483099819528435139680267*tanh(100*x(4) - 100*x(6))*cos(x(3)))/59863107065073783529622930748058952485106996960296960000000000000 - (31832600938975545674872054414858874644745664249*tanh(100*x(4) - 100*x(6))*cos(x(5)))/166153499473114484112975882535043072000000000000000000 - (8588535041775893103256212650425920046987946809111050150750843*x(4)*cos(x(3) - 2*x(5)))/1870722095783555735300716585876842265159593655009280000000000000000 + (98339534941614742092741786509418405997854933429151617519*x(6)*cos(x(3) - 2*x(5)))/598631070650737835296229307480589524851069969602969600000000000 - (62937302362633433442934568981285589147118689686138919819*cos(x(3) - 2*x(5))*tanh(100*x(4) - 100*x(6)))/1197262141301475670592458614961179049702139939205939200000000000)/((655038007423313314799336784206898633168295028516377*cos(2*x(3)))/3245185536584267267831560205762560000000000000000000000 - (50140201819251503691395212583595913238136122040933*cos(2*x(5)))/6490371073168534535663120411525120000000000000000000000 + (90040904114976191576180959019977846648383405212661*cos(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000000000 - 77794779510967865003137207957921727870986430894714021/6490371073168534535663120411525120000000000000000000000); x(4); ((357596495520240411269824179198373926964297856332055195693299*x(4))/149657767662684458824057326870147381212767492400742400000000000 - (4094513545693148053782257535430355171854644025910680967*x(6))/47890485652059026823698344598447161988085597568237568000000 - (626454800970153503093854757436867145830241989458301*sin(x(3) - 2*x(5)))/6490371073168534535663120411525120000000000000000000 + (419005771763748827951283610742839540151393*tanh(100*x(4)))/25961484292674138142652481646100480000000000 + (2620488669243614692114953854088240997528442698093684867*tanh(100*x(4) - 100*x(6)))/95780971304118053647396689196894323976171195136475136000000 - (120313548296940403142991188729793708239804280750351*sin(x(3)))/259614842926741381426524816461004800000000000000000 - (60911596040963780874157536527843404588566998646177660643623*x(4)*cos(2*x(5)))/3741444191567111470601433171753684530319187310018560000000000000 + (697443510224218029026537492974598624098261939213841259*x(6)*cos(2*x(5)))/1197262141301475670592458614961179049702139939205939200000000 - (446363846543499527964074957314082192532756664440701559*cos(2*x(5))*tanh(100*x(4) - 100*x(6)))/2394524282602951341184917229922358099404279878411878400000000 + (8771309403545004739999297401981036870880581866420429490856931589*x(6)^2*sin(x(3) - x(5)))/2338402619729444669125895732346052831449492068761600000000000000000 + (655038007423313314799336784206898633168295028516377*x(4)^2*sin(2*x(3)))/3245185536584267267831560205762560000000000000000000000 + (11696077570075492736222936317344653418844969571*tanh(100*x(2))*cos(x(3)))/324518553658426726783156020576256000000000000000 - (4101419926221590213475653552582464051877913*x(4)*cos(x(3) + x(5)))/1661534994731144841129758825350430720000000000000 + (4101419926221590213475653552582464051877913*x(6)*cos(x(3) + x(5)))/1661534994731144841129758825350430720000000000000 - (2624908752781817674213633792462803649370013*tanh(100*x(4) - 100*x(6))*cos(x(3) + x(5)))/3323069989462289682259517650700861440000000000000 - (8708918518298952149086326371812846923935197*u(1)*cos(x(3)))/3245185536584267267831560205762560000000000000 + (148051614811082186534467548320818397706898349*x(2)*cos(x(3)))/3245185536584267267831560205762560000000000000 + (90040904114976191576180959019977846648383405212661*x(4)^2*sin(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000000000 - (50242307354967719052467396803313495724325347*cos(x(3) - 2*x(5))*tanh(100*x(2)))/6490371073168534535663120411525120000000000000 - (71371813281825469733336130818012654794461*cos(2*x(5))*tanh(100*x(4)))/649037107316853453566312041152512000000000000 + (37410504359618554767287711692712952884829*u(1)*cos(x(3) - 2*x(5)))/64903710731685345356631204115251200000000000 - (635978574113515431043891098776120199042093*x(2)*cos(x(3) - 2*x(5)))/64903710731685345356631204115251200000000000 + (210210958820831061283941747250401675025188687*x(4)*cos(x(3) - x(5)))/1661534994731144841129758825350430720000000000000 - (210210958820831061283941747250401675025188687*x(6)*cos(x(3) - x(5)))/1661534994731144841129758825350430720000000000000 + (134535013645331876022969339520173462168916587*cos(x(3) - x(5))*tanh(100*x(4) - 100*x(6)))/3323069989462289682259517650700861440000000000000 + (111388742300392863961567812249768823457450101176159441144143211*x(6)^2*sin(x(3) + x(5)))/2338402619729444669125895732346052831449492068761600000000000000000)/((655038007423313314799336784206898633168295028516377*cos(2*x(3)))/3245185536584267267831560205762560000000000000000000000 - (50140201819251503691395212583595913238136122040933*cos(2*x(5)))/6490371073168534535663120411525120000000000000000000000 + (90040904114976191576180959019977846648383405212661*cos(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000000000 - 77794779510967865003137207957921727870986430894714021/6490371073168534535663120411525120000000000000000000000); x(6); -((71750396908954878475633433315147*x(4))/144115188075855872000000000000000000 - (71750396908954878475633433315147*x(6))/144115188075855872000000000000000000 - (3683960300598621448689700233027267863007*sin(2*x(3) - x(5)))/9007199254740992000000000000000000000000 + (45920254021731121132588748825047*tanh(100*x(4) - 100*x(6)))/288230376151711744000000000000000000 + (786996429098913805488663154030406656299*sin(x(5)))/2251799813685248000000000000000000000000 - (24119007725513996302969112659091*x(4)*cos(2*x(3)))/2305843009213693952000000000000000000 + (24119007725513996302969112659091*x(6)*cos(2*x(3)))/2305843009213693952000000000000000000 + (295457334542789423057700771537729*tanh(100*x(2))*cos(2*x(3) - x(5)))/9007199254740992000000000000000000 - (15436164944328957266884364393791*cos(2*x(3))*tanh(100*x(4) - 100*x(6)))/4611686018427387904000000000000000000 - (219998015296194656037007275903*u(1)*cos(2*x(3) - x(5)))/90071992547409920000000000000000 + (3739966260035309152629123690351*x(2)*cos(2*x(3) - x(5)))/90071992547409920000000000000000 + (196687188874798937900697435088329450054831*x(4)^2*sin(x(3) - x(5)))/9007199254740992000000000000000000000000000 - (419712525636002570737269200127*tanh(100*x(4))*cos(x(3) + x(5)))/900719925474099200000000000000000 + (50140201819251503691395212583595913238136122040933*x(6)^2*sin(2*x(5)))/6490371073168534535663120411525120000000000000000000000 - (25411691639862706366861670544671937*tanh(100*x(2))*cos(x(5)))/900719925474099200000000000000000000 - (358199667898629027542655695842302212191031798061*x(4)*cos(x(3) + x(5)))/5192296858534827628530496329220096000000000000000000 + (4101419926221590213475653552582464051877913*x(6)*cos(x(3) + x(5)))/1661534994731144841129758825350430720000000000000 - (2624908752781817674213633792462803649370013*tanh(100*x(4) - 100*x(6))*cos(x(3) + x(5)))/3323069989462289682259517650700861440000000000000 + (18921587222533660734818816488959*u(1)*cos(x(5)))/9007199254740992000000000000000000 - (321666982783072232491919880312303*x(2)*cos(x(5)))/9007199254740992000000000000000000 + (90040904114976191576180959019977846648383405212661*x(6)^2*sin(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000000000 + (21511616471892562276222448061273*cos(x(3) - x(5))*tanh(100*x(4)))/900719925474099200000000000000000 + (18358884725964029252033213963665861962287825762139*x(4)*cos(x(3) - x(5)))/5192296858534827628530496329220096000000000000000000 - (210210958820831061283941747250401675025188687*x(6)*cos(x(3) - x(5)))/1661534994731144841129758825350430720000000000000 + (134535013645331876022969339520173462168916587*cos(x(3) - x(5))*tanh(100*x(4) - 100*x(6)))/3323069989462289682259517650700861440000000000000 + (294856887807498438749677345211382198231*x(4)^2*sin(x(3) + x(5)))/9007199254740992000000000000000000000000000)/((655038007423313314799336784206898633168295028516377*cos(2*x(3)))/3245185536584267267831560205762560000000000000000000000 - (50140201819251503691395212583595913238136122040933*cos(2*x(5)))/6490371073168534535663120411525120000000000000000000000 + (90040904114976191576180959019977846648383405212661*cos(2*x(3) - 2*x(5)))/32451855365842672678315602057625600000000000000000000 - 77794779510967865003137207957921727870986430894714021/6490371073168534535663120411525120000000000000000000000)];

    block.Derivatives.Data = dx;

end % function Derivative
