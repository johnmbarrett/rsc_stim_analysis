function files = chooseParametricDataset
    datasets = {'ortho_aav1' 'anti_aav1' 'ortho_aav9' 'anti_aav9' 'ortho_aav9_muscimol' 'ortho_aav9_muscimol_pre' 'ortho_aav9_saline' 'ortho_aav9_saline_pre'};

    prompt = 'Choose dataset:-\n\n0 - Pick manually\n';

    options = arrayfun(@(n,s) sprintf('%d - %s\\n',n,s{1}),1:numel(datasets),datasets,'UniformOutput',false);

    prompt = [prompt options{:}];

    A = '';

    while ~(isnumeric(A) && isscalar(A) && A >= 0 && A <= numel(datasets))
        A = input(prompt);
    end
    
    initialPath = 'Z:\LACIE\DATA\Xiaojian\ephys\e-ephys\AnalyzedData\RSC-M2\';

    if exist(initialPath,'dir')
        cd(initialPath);
        isNeedToChooseTopLevelFolder = false;
    else
        isNeedToChooseTopLevelFolder = true;
    end

    % TODO : cleaner way of doing this
    if A == 0
        files = uipickfiles('Type',{'*.mat' 'MAT Files'},'Prompt','Choose files to analyse..');
        return
    end
    
    dataset = datasets{A};

    switch dataset
        case 'ortho_aav1'
            names = {
                %             '20151027-RSC-dmFC\AP0.6\response_stat_1'; % comment if probeNum = 2
                %             '20151105-RSC-dmFC\AP0.6\response_stat_1'; % ditto
                '20151201-RSC-dmFC\ArBrs\response_stat_1';
                '20151204-RSC-dmFC\ArBrs_1\response_stat_1';
                '20151211-RSC-dmFC\ArBrs\response_stat_1';
                '20151217-RSC-dmFC\ArBrs\response_stat_1';
                '20151221-RSC-dmFC\ArBrs\response_stat_1';
                '20151223-RSC-dmFC\ArBrs\response_stat_1';
                };
        case 'anti_aav1'
            names = {
                '20151204-RSC-dmFC\ArsBr_1\response_stat_1';
                '20151211-RSC-dmFC\ArsBr\response_stat_1';
                '20151217-RSC-dmFC\ArsBr\response_stat_1';
                '20151221-RSC-dmFC\ArsBr\response_stat_1';
                '20151223-RSC-dmFC\ArsBr\response_stat_1';
                };
        case 'ortho_aav9'
            names = {
                '20160427-RSC-dmFC_drug\ArBrs_1\response_stat_1';
                '20160517-RSC-dmFC_drug\ArBrs\response_stat_1';
                '20160524-RSC-dmFC\ArBrs\response_stat_1';
                '20160527-RSC-dmFC_drug\ArBrs\response_stat_1';
                '20160601-RSC-dmFC_control\ArBrs\response_stat_1';
                '20160608-RSC-dmFC_control\ArBrs\response_stat_1';
                };
        case 'anti_aav9'
            names = {
                '20160427-RSC-dmFC_drug\ArsBr\response_stat_1';
                '20160517-RSC-dmFC_drug\ArsBr\response_stat_1';
                '20160524-RSC-dmFC\ArsBr\response_stat_1';
                '20160527-RSC-dmFC_drug\ArsBr\response_stat_1';
                '20160601-RSC-dmFC_control\ArsBr\response_stat_1';
                '20160608-RSC-dmFC_control\ArsBr\response_stat_1';
                };
        case 'ortho_aav9_muscimol'
            names = {
                '20160427-RSC-dmFC_drug\AdrBrs_1\response_stat_1';
                '20160517-RSC-dmFC_drug\AdrBrs\response_stat_1';
                '20160527-RSC-dmFC_drug\AdrBrs\response_stat_1';
                };
        case 'ortho_aav9_muscimol_pre'
            names = {
                '20160427-RSC-dmFC_drug\ArBrs_1\response_stat_1';
                '20160517-RSC-dmFC_drug\ArBrs\response_stat_1';
                '20160527-RSC-dmFC_drug\ArBrs\response_stat_1';
                };
        case 'ortho_aav9_saline'
            names = {
                '20160601-RSC-dmFC_control\AcrBrs\response_stat_1';
                '20160608-RSC-dmFC_control\AcrBrs\response_stat_1';
                };
        case 'ortho_aav9_saline_pre'
            names = {
                '20160601-RSC-dmFC_control\ArBrs\response_stat_1';
                '20160608-RSC-dmFC_control\ArBrs\response_stat_1';
                };
    end

    if isNeedToChooseTopLevelFolder
        initialPath = [uigetdir(pwd,'Choose top level data folder') '\'];
    end
    
    files = cellfun(@(name) sprintf('%s%s',initialPath,name),names,'UniformOutput',false);
end