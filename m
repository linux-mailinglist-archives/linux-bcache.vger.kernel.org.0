Return-Path: <linux-bcache+bounces-278-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55BEF858C09
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 01:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CBB828305B
	for <lists+linux-bcache@lfdr.de>; Sat, 17 Feb 2024 00:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4E3149E11;
	Sat, 17 Feb 2024 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YiJshem1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N1Ppaq2L"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276315381;
	Sat, 17 Feb 2024 00:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131119; cv=fail; b=W2mxTh2yarw9IIgmjU0wtOoZIgUKzE8xvYSM3blBbguzoAJ/W+315trkMa9WcHjnFxCUSNSHn3/995C4Jxmk/inFTBzIQo/09EhxyLpPV7RhJaBgDAgz5QN88jyyfhsWWm97fN2gXEfDNmyT/1xHXkBg+Mozr7Bs1nfweaXCLZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131119; c=relaxed/simple;
	bh=dxcxFJ6YRljvLjwnzAhLID3f0sHOLOEiUrXB+kI5k+Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bgzVa52vt14zQ950Znj9he+XHwWc1rIXXq6hT8Dd9shv9+UCDYYsCdSk9BcOH70PfnY2iXAe7GHI9S7hxQksXMPi2KBtmXtTpJO6bPPLS3/24x/Lmr7e/Zs3J0ee9lCf+ttaSBmiSV4UDu0B7X2IQP+KzkpFK7586WsY+MPg/B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YiJshem1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N1Ppaq2L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GKEHFn029574;
	Sat, 17 Feb 2024 00:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=8tmdWF7sZWwhE74PompL2GxeZ3h1RmyUTONs6fKl5Ss=;
 b=YiJshem1zJ8S3mudCq+NNShlcm1t6OUUSJSUnHI1GTcVcMf53nxC+gIn70f2HNKxnSVZ
 32IPTZqGrbyra7I8C+yplnmvyWW8LTXj+qFF0pudFfCRBFRWyfyEf0QKC9prNZI+JHD5
 5XRIKeXA9pUwl9coIlX+2Nf6UVhZQwaBdgV2Efw4+fY1hbzsY2GwqfVzoIqEyosQBzN4
 g/eWBPwNhBlATjP+u9cn+D45p6B2V928nuhjoRv0cOpBxsXBDbrF2A1ORyOz8cjSt3mR
 6W1m5nnuxmtgI8sRDc1Rr4Y3lgVl4YPC1KI8nU1F2i1e8FuLpKrHAhQVw5mEOWe35n7n Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91f06swd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 00:51:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41GNqcMh015173;
	Sat, 17 Feb 2024 00:51:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykcmcy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 00:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWN4DdttYizlxDXyVKF5GeZF0/OZGrXLwp7ExFaZpPLito8NF2z24PPki9uhiQlEaNYjFyfxmZezEnWykJVH6hFUcCn8kQVs3jPoFjxeQu7KANTxxy5HWdHVUBx419XJUeRhz1zNHSG6JGxcKUegZKu7+8M+jvsoOw91qIJG7umTLOa+QFyps4h2hh6IXoE5VolqM4+ebZv0DXQv+3w+wZHI4pRHUGmFOtpXibjBwiphO9FILO9uhlkXjzDol4xqOwAyN0gvNySYU0GQT9ZT5mGHH3uzeDgu6fhk28UDk+evuq3iH9EEAZO7bYCC3Y5gv84D5d6OJQhwBFed3dpZIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tmdWF7sZWwhE74PompL2GxeZ3h1RmyUTONs6fKl5Ss=;
 b=Bb8jvcKTPdAOfIXFp74nU5BB9NzPNDlkLr8ca88cPMjEp6mja8VP/hypDBVm5XEF/SIPVAXYuCz8jGb15YHmlI7rxQ2TtsJRmv4MK0HNcmpmVUbG8wObkE/fup6z6YGifq1nkL+sCYgVvI9D+vpa0RNpLva9CRX+HM6O+q4Dv5CWCnMxFpl6cq8bzp3SzMspFjCghH96USoWdMWF3QBfQKfxqCRk1kE2CAcuTlvsDmz0cgY1xHXlG03Y6u6OGy2Ji7gTrFQbZM2J8HK70Td6ChufuVI9T1+zp4OmZaVbrVc4UUikcLvBJcQS58ZE8prna0I0aM34IB/D8aSVu0vQhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tmdWF7sZWwhE74PompL2GxeZ3h1RmyUTONs6fKl5Ss=;
 b=N1Ppaq2LGlUOVPWA84vZvv8ccHwvs8pT0TCudfVT4oeOIsV9fQekZDJG4OX3hPnsvVI1bPP39v4s2QcHPVz0ZjiafX5GTf0fXgk49XucNsdcy4A9c2KelpjVk9OCXoR2+yMYrO1DaCeywf2AU5p09n1pUnfSCdUk5tDp47s4rRM=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Sat, 17 Feb
 2024 00:51:32 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7292.029; Sat, 17 Feb 2024
 00:51:32 +0000
Message-ID: <9e3c5e1d-fe48-4014-b429-b6967327d32d@oracle.com>
Date: Fri, 16 Feb 2024 16:51:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: pass queue_limits to blk_alloc_disk for simple drivers
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Coly Li <colyli@suse.de>, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
        linux-m68k@lists.linux-m68k.org, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-block@vger.kernel.org
References: <20240215071055.2201424-1-hch@lst.de>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240215071055.2201424-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::24) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|SA2PR10MB4506:EE_
X-MS-Office365-Filtering-Correlation-Id: d2fee2fd-7c9c-43f1-3cbe-08dc2f529570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	P++n6Fq0pbA/3gXMGwbA7IK96E32JLZ+76Ybf8XXPJxAnr89XpK/zd5D73zRlb4kmMPPc8Sli6ZyAJtDdDkXJzcrohBHsWqKIe3a1v+6P7sY7Wb4g7rBOS62O7uWJInG4ySdoYAc9xYfASHmBuiEZTqrY5zJo698gkyM1uGZbHr9sneaSn5fQH3TWg1ztCmE1y5O4oAB8WGsRuKfHcE/fUWFyvd4AMTmfLqDtFZr+tVSisXEXWCGahVPqd+iyfC5c/J0fv4I52piuBw6lRHkUkopZ5GqsaKN2F4uq37nBJaWhOWs/RIm/89ZrV0q/ddRB88ZQUZZ02Cf9z9VwMkUBPJHbkv1b/A88HAL5gkyGIoHLTvKtMUaSUvHmxyI5NPQ6w8q9FG4B/X46l3LISm+mBp72+68MSOAO1w/pe8XHXbrI64iyeDRQtr6CtMYL/M4U4TVzJs7hOYBi8jXbT+Dut/W4JC3CcTxymYKcQjQuAzPJ3xQ8yAF6JkJisrK4x2+iPBHKVPq9ZE3XX+KLN0gtqpg5zc4PiV3psZ/TPxub1JCcoglErimrA+wUKQ9zkYY
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(366004)(396003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(7416002)(44832011)(66556008)(5660300002)(66476007)(66946007)(4326008)(8936002)(8676002)(2906002)(38100700002)(6506007)(83380400001)(86362001)(31696002)(36756003)(26005)(6486002)(6512007)(110136005)(54906003)(6666004)(316002)(2616005)(41300700001)(53546011)(36916002)(478600001)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YjlnTnFNNnhXQkh0SzFIOXR3SjQwSG5VMFpENlp6Ny8rQzRRY3N0b3BVMFIy?=
 =?utf-8?B?bWtKdDZqRG9FVGd6ckFQRCtHU1dLcXkvSG9zRUo5WVgxazBwbnNoeXVqaHp1?=
 =?utf-8?B?bkExRyszdG9XSGViNVN2MXhURVJNNVhDNzhTdnh4MHFJQ0JkbGRIQnh2RnNy?=
 =?utf-8?B?Rks1TDA1dVEzN2tzeHlWMTNNYzZTQitMNGtCMnBVMW5DSklwa0ZHYjdPN3Fz?=
 =?utf-8?B?bjZGRkFnUVU1dTF6WTIycE5oRkRBcWVuMTkvY2kycmw2SzhjYVdZUGxHRjFF?=
 =?utf-8?B?ZG5DdzlwUTc2UVZtdThCRWpRd1BzckFCbmM4QUw4Z0NEMk41THFPTEJxTXhQ?=
 =?utf-8?B?N3FLQjhxdEFpUnBRN3d3aldJZnVmUVE5WGZSZ1VQSjEzbllZbkMyaTlFbkVl?=
 =?utf-8?B?L3Y2VWZ6MWMzNzhiYTIxWmR6d3BhZXJ1RUpvK3dGc0pUM1hFalRJUHRLSUR3?=
 =?utf-8?B?SUtQT1NicXhVWmo3VEtaNGNKMXd6WEpUYmZPQ0VXQURDUTRaR2VTN3RNaWhX?=
 =?utf-8?B?cmV0NGtueXdaUFlzdndiczd0eFBuQnhVeEtNVFNIQ3kxZXRBTHROUHVBZzJu?=
 =?utf-8?B?a2tCeG1oMXhpcmFMb1FNY3o0RWgxYWJ2TTUzME1Ba2liWDU2bWlSckFCd3hS?=
 =?utf-8?B?eHBuMWRUNmd0WEZWOEpXSFhxU3VqM2MvZXpFMEdtcVhmTVk1WEpPeUpHNlMw?=
 =?utf-8?B?dWRjV3I3OGVWanQ2dmVZKzdxK2VEUXJYOGdUT2c4OUNoTk1YNFNuY0xha2hJ?=
 =?utf-8?B?R1hxNml2cXRWR0hOQ0RURTdlOXBFNmRaMmVEckdOajdYSmVOQ3dqR3pudkY5?=
 =?utf-8?B?Zzg3SnVzc1UyeVF1cnErUG5MdFFLNWdWU3pMMTdTb1dCMUFLTDhIMHBpNFFP?=
 =?utf-8?B?cVVFTFUxMHVVQTI3Vk92d21NT3BMV21LaU5TaFc0bVF5RFA1OHZ1endMb3BV?=
 =?utf-8?B?S0tsMWFjZENVdWNjWDJJVXZFdStLNVFDNm4zS2R6Z3JRTTUxQWpFa3hUZDBa?=
 =?utf-8?B?NFFwTHAwNUM0TUFRa1BFNXdLQW5ueWlHUGxoWDlLTzlaOEFIUGowWUtvSFIx?=
 =?utf-8?B?dkNoU2Nqek5rYWlRZzkwL1VVNmMzUFNCZ1RlcHhhbmVDOGxSQjNIMDJQOHha?=
 =?utf-8?B?S1BZYUQrcFZiVnpKRXBIWmJuMDI2SERzejJlUVVIdXErUTZGK0lvR2Z2YlhL?=
 =?utf-8?B?czJlWVZQd0JPVzBONmVFVFBOUVozMHd5aWs2QjR4N1FVY1g5TDBITEdleXpm?=
 =?utf-8?B?emlnRTc3ZHBJbjF2aG5VNmtSMXJuNS94V1QwRWlsOC9LKzBFL0NoYlpDRlNu?=
 =?utf-8?B?OTJacFRTd3ZZQm13emd6MHpUclp0dy9nbkl4akxrNUZjWlBkZlg3R2tQYUM4?=
 =?utf-8?B?c3VVNDZSQ1d4Rk1qbHBUSmU3Y1FXWXQ4RHRqaTRlODBYQWVwK2pxZ3lOVHpa?=
 =?utf-8?B?U3dBWHF1Mlh4ejE1dXBaTXZaeWRaR3NJbFhLRXVPQ1I1dGkwM2c2SzZocll5?=
 =?utf-8?B?L0NVRjh5b3h6bUxZTE9tenhUTVFLaHZxTVp5UWdwTWI2T0dKUVRyMit1bEh1?=
 =?utf-8?B?eXVDKzJXZm5xdjZXYkY1dnFQZE9MUjZuUTNhTDRvTXVRR0dVRGFYS0xYdTdN?=
 =?utf-8?B?S3JJZEhCN1NDejFtc0RTNFFNN2pVMzBiUjdMM2hJbW5tWHk2QzNsZ24rbVIz?=
 =?utf-8?B?WjF6WE1GcGJ0RjR6Vnc2eS9TanRnTGtPNE5MalFnWlVVYm1GOU83TENISmdr?=
 =?utf-8?B?V3hvVS90bFd4Q1lsanNFRW1wdHRsT3Q0TEY1Vkc5ZVR2aHNjcy8zTU85cmQr?=
 =?utf-8?B?b0FXTTRjdml4djF4TjcrUTlVMnpnVlhhUnY2Y1BkYTlNdiszblYvVXlaSHZR?=
 =?utf-8?B?b254QmhhWnNHbjlEbUhmOUpHRDFFZ2N6ejkyMTlpRytJWTRIckdtSko2L0VH?=
 =?utf-8?B?VGdhQm8yb2E4K1hsVThrUDB3WUpUQmNaL0czUWNFNmxvNFgzL0RETW5BdE1i?=
 =?utf-8?B?REFYQTkrQmFBTkNUdU5NbXJvQ3ZGblBJSVpCRUxPbndmMVZBUmxMUk1wRk40?=
 =?utf-8?B?TUFtdFcvZkwvemVldjBLOEZsSlY5VGhBZkZLL09UZFlPd29HT0orZVRJYXps?=
 =?utf-8?B?SEpaQkRxY25IdHdXbXNSYUp6QmwrRmJrT21WTXZyQ0oyODdkOStQSGpjT3VR?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Pib4aUhCmi+U/JIaUPRmuOYsqUBEP9gGQrt97RFCvx2biHmhSXSnJXOmu+NWhlfNMLzHpvPwkbuFsLqKl0o0qns4FiHXfAa/XTPGpfVr/v5tgNpOj4vHOeZL1Hj0r4ZKkA7GymFgIjNqwrdFtSsV0PWQO+r2qRmYK8CS1+bA8XRb3qrlwNCoM4wL2F+y4DYcFSLfGsBK9e6c29DtTU0Q55s8WGYHEm1FXTEH7w0riRiNaGbR3svOpI+AgQzz8GYyCe/9iEcHwWumy48CF0l7WQP8IoPojsVplt22nMzoPlQklZd0eQ6dGZk8o7cVWTh10XDNtAdNatSjWPWteA7M3gBp7MjoA9lyRvYTiAH6W8c28sdp5kYF83bfOn6hxXXFA5ZJQdMO9lNU69gWrxfXBihTfBTr/3u6Ds934nYo9JZhVj49tjTexwODK/0t7c/Pa7MzCvnDfWW8X/LcNhjMyGkH1oZAwaxhjn5mBPjytdWDIOuYcR2Ov0dNXEC72QKd6iHtQ0tR4vw8VRd7xP7eo7QZhb+AujAzbYsE9e8oAiZ1+z+M1+1yxX4uAbL5oiG4e8whCjl+F9lEecumAba9dv258iQ1PlzGr5N0LsfqUfc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fee2fd-7c9c-43f1-3cbe-08dc2f529570
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 00:51:32.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeqXzrlbYfX8TP5YtL9qW9urlYQg6cOPnsuyEtRj0LOkl8HtL/iXUKPi/X06ujBlIeJGJ2iJTKjPgv5xK3jQvujqfEvI6CHpQn4M+Xu3PLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_24,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=981 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402170002
X-Proofpoint-ORIG-GUID: hsG6vMz5zk2lFeuMDp16W8s2v7t8UTjx
X-Proofpoint-GUID: hsG6vMz5zk2lFeuMDp16W8s2v7t8UTjx



On 2/14/24 23:10, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series converts all "simple" bio based drivers that don't have
> complex internal layering or other oddities to pass the queue_limits to
> blk_mq_alloc_disk.  None of these drivers updates the limits at runtime.
> 
> 
> Diffstat:
>   arch/m68k/emu/nfblock.c             |   10 ++++---
>   arch/xtensa/platforms/iss/simdisk.c |    8 +++--
>   block/genhd.c                       |   11 ++++---
>   drivers/block/brd.c                 |   26 +++++++++---------
>   drivers/block/drbd/drbd_main.c      |    6 ++--
>   drivers/block/n64cart.c             |   12 +++++---
>   drivers/block/null_blk/main.c       |    7 ++--
>   drivers/block/pktcdvd.c             |    7 ++--
>   drivers/block/ps3vram.c             |    6 ++--
>   drivers/block/zram/zram_drv.c       |   51 +++++++++++++++++-------------------
>   drivers/md/bcache/super.c           |   48 +++++++++++++++++----------------
>   drivers/md/dm.c                     |    4 +-
>   drivers/md/md.c                     |    7 ++--
>   drivers/nvdimm/btt.c                |   14 +++++----
>   drivers/nvdimm/pmem.c               |   14 +++++----
>   drivers/nvme/host/multipath.c       |    6 ++--
>   drivers/s390/block/dcssblk.c        |   10 ++++---
>   include/linux/blkdev.h              |   10 ++++---
>   18 files changed, 143 insertions(+), 114 deletions(-)
> 
for the series,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

