Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288C93340C9
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Mar 2021 15:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhCJOwN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Mar 2021 09:52:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCJOwA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Mar 2021 09:52:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AEnphd023541;
        Wed, 10 Mar 2021 14:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lKLYA+GN2c/1dt7BhRAYkbu51YMrmzVSHPGX2zyOlmg=;
 b=JZ6R4VyeRry3WreFnHqCLqOPrvp66oh4DhPpWWB5X9piDV4JryCQOvaKOJAegF4tEDt5
 ixk9BBjmkhCJsfgUSyLwn2FRFSsZMPnLqxmwzmvVN7Tn6peQlHma3R6q6dwhUq8ecA48
 aqTbh+DFlpIy1J0omjcbFjTaD8AW5rnz9gXHIrHJNs0lOs30QyXTZpPu2iRzrbgrGsYu
 +bx4LCSSYQMdx6pyyGefSkS+fAQxjO582EkUZpUuyv8+nCbpVN5aQ70c+ZjWhqVWJ4bh
 DkjZB3eQQmOmke3EerFima8Qmfwsjcaj6IwZQZYe/zUBAXdE/p0lzVKRV96MRwk7FnhP jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3742cnb6vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 14:51:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AEpT72191987;
        Wed, 10 Mar 2021 14:51:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 374knyfhar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 14:51:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbId3IUarew3IrJyFJIra6+vjXRa2Wa6TC10qH6MYWPdkWWjHznMJK/5e57voJEnFrgy2ryNeXnHslxiSNZDhONMEfPJIhyv4VEDffva608SlZU4yAF3vy9XcUhE6+TfaZt2PKnd34lzn9X2XALw6mpl1pglD7g5gUgdtIsxxGtPmykXK5BCkkoG/b+9NRhuJTnWOC6rZ41V3+hdtRa/4Dm6sc2kl7rpfE4qHPmlNUtZFO9f7lQw4VKz/25npApo3hkOo1kAOI6U15OLPnq8HlXe5OGBPgbmzsk6hnyB2OR0T6pdBxHARlSy1Caa46BzO/JtmyObWNc6GK0/0ouDHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKLYA+GN2c/1dt7BhRAYkbu51YMrmzVSHPGX2zyOlmg=;
 b=llHMhBeHjYNiVP49dW75+XZ9KgmC5vNNXEkCUltTOi/wKQJbTc80s24vRXK6dahk8xRxT74siAEPtHwQsiNyHp/fd+T7+u6iGDgc5YRBg39e5kw+rSmCMHmzBKOvEP0X6iUliq+tR4XNxFmQHO/Dd42/250JE4azZdeR5MG3zNwncBmM6wvK8KD4ON9/1W1twZV0giI5mN7M6mN5l0LJgdNLgE3JHQ4wrxSv3yWCZJbAUTeu9u8Yr8N1z3Eth+aAHbBq32BSCNA7grH0t2X3VoffWKicNGrb8Rp8txk7f9cEHXIbXyNCvOSC600QcG9VoG/+PSBDPbRSTGfnQROYhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKLYA+GN2c/1dt7BhRAYkbu51YMrmzVSHPGX2zyOlmg=;
 b=bF6U/lDiffdzLjnd26u4AHS7Yq2FlAV7VFY6veqt/nP8Dvp0pCbFS2OUHv6tioWrAVXutW+uiX/jbPfr/Qq2PJg3acfhLZchRzxk9geNXbCKGN30Ur9X+wwmaRV5JcOZaNsje6p3ij8VyvNVqkauSt+IAqKLJa7RWNq6j0lvWk4=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 14:51:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 14:51:42 +0000
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] include: Remove pagemap.h from blkdev.h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft139i5g.fsf@ca-mkp.ca.oracle.com>
References: <20210309195747.283796-1-willy@infradead.org>
Date:   Wed, 10 Mar 2021 09:51:38 -0500
In-Reply-To: <20210309195747.283796-1-willy@infradead.org> (Matthew Wilcox's
        message of "Tue, 9 Mar 2021 19:57:47 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:610:59::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR03CA0019.namprd03.prod.outlook.com (2603:10b6:610:59::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 14:51:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f85afa0-9670-47ef-8669-08d8e3d404be
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4789567DF238A9DA434A25638E919@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ArQvDt2eSOFLXRkD2j8osAB6Us8KcLd4G7h4KOHMz/r7ttZF+QetVOMOXCFLMGXvMAkoZ4mLGIUJSAfs+pQX9qKWvoNn4p8oiovnozuCC2qDPWtYn1/Qsue7cpGwh7N3WllfhCJa5mlN7KRKnW4Qpp+YQtE/GmH2fYFyUiMdkhHOLKSC1nwHYczKUilwX8aFzxPdaUNH80HbP6NkLbX9Z0iT9lMwxmlKlQM4ubp1TxeZK9aVRIPt5es4XkKHMRK0eKPkLzNLnOz/AnpFwLa8atXcKrnDcLjDTyLngwMlBbLK1USIBrIM0Mn6Ygxf+P5qdTG+QN9LtkWqSkRbTa5MOwgc5CbT/k5Tgk5cpAA1oIUAXPG3QKacRgLt8Lf5a1njcYRpBuGNLcSdH9BFjqo7h9dDPF6DGyEmiUL9Xpl0yFwaYEn1zO+fUMOvnZcldPvSiyJiiranV33DuSVVPjeA+oNgI/GQEMr8NoIAFCquaZufrxkWOH0k8AAb8kWH2bKUbz0V/Tmz62Upc4HD6D92A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(2906002)(478600001)(55016002)(8676002)(66476007)(4744005)(4326008)(26005)(66556008)(8936002)(52116002)(66946007)(956004)(86362001)(316002)(16526019)(6916009)(186003)(36916002)(6666004)(5660300002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3kuccfVWdICyxNj3MduGF4t7Wp00yuqC+PRtorQZ4LNfUZxqfszsiBieOKBA?=
 =?us-ascii?Q?sTXBnT+PannOG+cUOVic7f2F/7EkbZdQYhzXyOcm81F95YZYc1SEYbL9PN8b?=
 =?us-ascii?Q?KNOXbrUur6QXTO9JdmfKsR53EpueVRExlBcRsPZ6/CBUml7x159AI3pe+ewI?=
 =?us-ascii?Q?K8Xq4vjMANTGBNcRKyu0BuWAmTTsF4oyHQWT5aIdf+hr+unLidf/JH5grjQJ?=
 =?us-ascii?Q?cKOHPrjxmQBl3xXMG58ken/F9rheQcinC2ZuWfSVlluJICPOhCV3RhjRnf8w?=
 =?us-ascii?Q?/Gz7xrMRQ9Z+exqj1NscFLEhfivsezn9dr+j6bxDRDEh+YsqllR+wLTD+xxR?=
 =?us-ascii?Q?fz97ZFtxsvcvxmFP6C4RfS6ppqr9uhBI8zy+06nvSw1jm1z7aHPlXB3LDNey?=
 =?us-ascii?Q?a3D1qd4Hkv+f28mSjCZ7uSbN7RHcneBkHzq0tw4EsgZ9k9ISGztdkyuYj4Ge?=
 =?us-ascii?Q?ImEbjWyskpuwr34Qe/8SGiJwOAMQ2hRN25IgGL8ObLzOyoO2rqkJS8eLwL8j?=
 =?us-ascii?Q?Jhrmq5zfnlBDP9hpAEIZOHVBQbL87uC/rGeIQ6IzS4meLekzXMxUBA7JJTnD?=
 =?us-ascii?Q?PJwqAjb4VdSI9mr0A9v0qNwxZoufm8m2kEjaKI13/ynsNfGN9icghkoZCGFS?=
 =?us-ascii?Q?IimUouwCjId65G34HvCtr5iugHGXDgbr9NOHYlybIhi6/710SFgvUBg/2CgP?=
 =?us-ascii?Q?nAhIFkkQUigCVynQJT88NzUpkpDPeiL6dfOpLY6/DuhYeGfp5+lB8K6p0lyB?=
 =?us-ascii?Q?KXZ7E5W/TxT/OziJOmzqCbUIgdw6JwcGACsI6yZ9mtT/359PHaoGU7DpJhYM?=
 =?us-ascii?Q?uaPtrV9s1Of3bYwMXb9WFAjvPOFWTXJG+F1GVxtC98TZnd11P14OwsJiLdtN?=
 =?us-ascii?Q?KIpqA2B8BGncCGwOfX5uwCF5D6nieic0AGXIngKQ3TFjLIud1h0hNm8E5rTV?=
 =?us-ascii?Q?8/j6VPkzzQlnZ3VINiYSdN4w5Dm3/vbc/mvxiTwPk4XMikXQljiVK/76g9gC?=
 =?us-ascii?Q?ekGbWplbNELpqqeZF+d/8r3NPtgN8wL3obz1GuurxYiljycGR81znuniuXBC?=
 =?us-ascii?Q?hS3oGM29SkJfIPb4EewhSLbKb8cGBDg9KscGNNhvrWb0yOQ0AgCBkdL0sp0r?=
 =?us-ascii?Q?laCG4ClIWy3J7AjlbJdrFMqrg9iaHlRacth58krullnc4DVF2zznYmYU/RxC?=
 =?us-ascii?Q?1UaezlVY69aK/VaUEySCAKU+wneHeQ7NSijv8tcGRBebmMwON8DnJOAiftbl?=
 =?us-ascii?Q?btaZRmgCcXXLx3CKxq/LsoBF8jZA4E7k2VH+i+2DZm4TxPuGaTr4+MVpLGKW?=
 =?us-ascii?Q?RFuKXNYVDNIVs2Ixgk8HZh8H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f85afa0-9670-47ef-8669-08d8e3d404be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 14:51:42.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjlm2pwEED3NYrcXvoeMh8PUvuChmEfN6Rgho/eOyj7eTsoVhU/VfcMRs4MMysXXrtbVlIZ5bhZ6rarqjNUO6ppcEsclAi8Z5L/dUjL5lkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100075
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1011 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100075
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Matthew,

> My UEK-derived config has 1030 files depending on pagemap.h before
> this change.  Afterwards, just 326 files need to be rebuilt when I
> touch pagemap.h.  I think blkdev.h is probably included too widely,
> but untangling that dependency is harder and this solves my problem.
> x86 allmodconfig builds, but there may be implicit include problems on
> other architectures.

SCSI portion looks fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
