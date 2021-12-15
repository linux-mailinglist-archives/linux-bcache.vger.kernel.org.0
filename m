Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E58D475D43
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Dec 2021 17:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244734AbhLOQVP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Dec 2021 11:21:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1152 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244732AbhLOQVO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Dec 2021 11:21:14 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFGB5F7013377;
        Wed, 15 Dec 2021 16:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=QiMwb/MZ9Yc18256D+wjc89NwCfPxNB5dsV9LUNii5s=;
 b=KgjH6OV8zh2m3n945J8p+E8C1PA1DkinpAAQ/ynxOijI01lC5xF9GW4SfnpKtmV15Ko2
 dibnusaEvQyrnmgta7ITSE639u09gmPAq4XFcWJlZx/q/oXtVRu0JMTwYW0+ka5aDRC+
 wYCeJdjo3Tw7XG6ogdMNfvfDwSIYDNK3i4ZE0HfzF4dFUpGAaLsmIezwfkkrQn9c/OmU
 +WBCkfNni56YNo7mqK92n5OX+xvQ2Q44g9g94jTcNr1pTyViox+8UAvKh/GD9glE5cx7
 jNc9oi8R1Td7K2DoTbKZ23Lt61599wPKJgsx3LRSBT40VdNb4Vlslpj6WICz27SCw4Qu BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknp011f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 16:21:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BFGAeDe072039;
        Wed, 15 Dec 2021 16:21:04 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by aserp3020.oracle.com with ESMTP id 3cxmrc2ma1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 16:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKix4rdGek3D8iqOZVAqafnCwEARV7yGW41sNWI+c+JncbrmHzfrGhQkClyuZ2d+dBWf0Sz081BsZy40c/9rm0ONNF7gCoDvSnBQN0KUk8t/NmAR7E/nU5Xv3kujQvOsOMwDNJwe0qs2MJybc1DOj22wdnnCZzyDwHFA5Orrk7rQnu9RlEiuy6tA8ZBn9VopWDtFvShpAWafCHfea/yLRPnOU1xJ0C3Rx5Fg3cvzKG2j0SSIapW10mEb1mMRxlexbyS+cCJYsLZqwGiBecq0nvbcnuJn4ERsV5vGN+P3zQa0Pqm8nNuhhgHOO1whATqETSTwHnNHhj1zWzZoG3krow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiMwb/MZ9Yc18256D+wjc89NwCfPxNB5dsV9LUNii5s=;
 b=PO2KVOLaNU5GPqe7U88l58wvCEj3689J8P/lkAJNDah0W8b+M8/xs1L/TPTwM0XeHiFV/BEjR7DE9K5fh1MDspZ/6XR/P/l21/pemHGQIdpF5d01tkOmJdd7Ew0L/W6atPZdkQo9CASy85BeSPUtDPFrEMpyxLeTyLTILkgTLvOeoYX8evD75/7oI/xVfW2HFFiMWYgMVC5s5Xj+P5DtIqnk73fQbYZSiaodRjzKw6NL9fF24CsRbc2muZ8mPkNU/kkvIjTWRNFBDfZ5p0kOYmZDeWX3ZDAzY5lw9E5A+v1OviPdwhzZdg/geDkOdIdL9vYqWg+X5WLa28a8I8trSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiMwb/MZ9Yc18256D+wjc89NwCfPxNB5dsV9LUNii5s=;
 b=HFSZbIsP/zeW5HrRl48gaqSw4QlotFkmK9euHYWX+KhcMGx+Hqj+WzsDzHuusDykXaYpZjlpqzLNptEipRBcjYgVYo3JuYn/59y0w0YEZov8S6/qbbJPt1RzmoanNfm54JW4QRqz1/OvIMA8alXDs5K00V73+8ahcm+hdHltD6U=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5790.namprd10.prod.outlook.com
 (2603:10b6:303:145::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 16:20:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 16:20:41 +0000
Date:   Wed, 15 Dec 2021 19:20:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v13 03/12] bcache: initialization of the buddy
Message-ID: <20211215162005.GA1978@kadam>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-4-colyli@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212170552.2812-4-colyli@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ba30bb1-02fc-4f4d-c0d4-08d9bfe6d57d
X-MS-TrafficTypeDiagnostic: CO6PR10MB5790:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5790115287ECE7ADD605B36C8E769@CO6PR10MB5790.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0HrxwGgXkEkqeN5xZMAqzZoKScDqbiJn6n9AC5LYyqEO4McDH1oeMRpwdiW5JVtDyd8IXl3jpH1dj0jmN+eRdQwMyC97d/0diVpWxM2tnnpJMeY0/p7IbTlxNvVJU27I/IQmHQqMWkMRhPDWSeJMz7U/G0pAq8n5JSEkXUhmJsLQvHAfvqz7SBm8M7g0+FwD6m+nZiG1RE2ikH1gYkvM3h0i3DP8dRNJr22IDfPRWwy1w/YEUmEmTK+1Pc5RwJ4Jt641uSGpW0vxLNdUlJbH0vQDKmMQ5WmW+HFRmwmlBJb0gWj6/p7bJ47PuMK4UYn0eplrw0ZRTN1KBsHe7sYAJ47tloNO/r19488n/LIn9QaodWJNS8d0I5mk6dlHM3HZHyOr8yxUV0B0VKJemILHuDKN9TMr1wFe0yQVa7cpO+WZ+KHn/e/A1je1VN49JjT/vLCrHqqmSLwI3kZVkSdS17EngoeyR0Udi0VP66SdXiyDU77BiQYlfSNtLLT9B3xbmHB23+IFc/Lb//2cqXjtm1QbD63JcHT3FE0XCwUFUmDQBWYHarjylykWPbT5kbRxHIGP6MpB/YMlNb5ctLGzoTvBeCM+Nn4jx2kN8IIzY02F5WJA2FcdMkIYxfDTWhNi25GXph+uj6o1TphuVoBYknDQn6cl8qlAg9w6gzsJOWMqfPeYGC9aiMC64NTiKdoFVGKVkVCKuuzSbBhVRNtKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(1076003)(2906002)(4326008)(4744005)(8676002)(186003)(26005)(38100700002)(5660300002)(38350700002)(6666004)(54906003)(6916009)(8936002)(6506007)(52116002)(44832011)(9686003)(86362001)(316002)(6486002)(6512007)(83380400001)(33656002)(7416002)(66946007)(66556008)(508600001)(66476007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lup8KDL08hB5a9+PCfHACKwgKyNAUKUseLwLgIxbkVNDgpk2SAx+i3HI4SLG?=
 =?us-ascii?Q?jbApcECb3n6j8ixXMPudXnGzOMa8gUWXZgGXrCjTG5IcEHHyJ+1G9WFejqZX?=
 =?us-ascii?Q?7CDkl6uEomxCrq6vL6uBlGIgi+FVuGNPu/AGCCIWzXMJamrO4unG0otwRtki?=
 =?us-ascii?Q?Qd+2VugnQETdKx45mf4nbMEVwC8yRydSbp0NM2c8hA6FBY/Gr22p7VorbXR4?=
 =?us-ascii?Q?Haxw1s2EGXK0XrTHrNPYzmCnFTGOdm1dkx3k/Ik1I3btlmfDDAIGcM/wMJ2q?=
 =?us-ascii?Q?ez1nY24PnCmDzzonTPdIeWzW6JYQxi0wHUkWp/C8HwfMCayFhrXvzkxMT68f?=
 =?us-ascii?Q?M5MJc6npK/P6VJDDBGuGvsvU2Y1dP/zL7GTIA/LSyuqECA2vwlDR6GcSNl3B?=
 =?us-ascii?Q?5HgccTStAPOuDzI5b+Maoc+vdH6q2lvDRcLLjtD8lGGvcin6b2SppcCCNNeU?=
 =?us-ascii?Q?CrlpEYkKeVSMXY1jZOd+q8G4NzloeqReMU74MjR+rm0t8iuW0dPcXoG6n8O/?=
 =?us-ascii?Q?ae7Zq+koJDsaua12Wzr2cDQmN15Iy5wK5EMfDT+/zhCtBmkPSVs4dDvE6iUF?=
 =?us-ascii?Q?RyrYf2PVb5He/rtGQvHmsFUWytAAJMTsa6dpMMb3gtjnR+RSp+AaSUa36uhj?=
 =?us-ascii?Q?l8/A6lyadwejZlw6BSwId1ptJu1+f1YuPiHPjJHdbdP54FEpXHV8QE0qTZ2P?=
 =?us-ascii?Q?xZComKPhslyHhiBwRPDF1bS0LY4dXW1FhANb4r7H9KPqET3P+6QE8OHOJB0A?=
 =?us-ascii?Q?mKrDWCTHxyxCTXbZFqF0NoPWmXr9omhv0FKxLOo0UgyyFvElfNHHHHl/N3AL?=
 =?us-ascii?Q?74iO0mcngCt0FeGOopctSAOJv79MRSz61o4WeitWfpymfnJ38KTTWr55GAYw?=
 =?us-ascii?Q?VHi6sdnOuaoPdOCS48+FHCGyDbFPsEZKCttTuHZaf5UfOnNUm2X+iQ23GXTa?=
 =?us-ascii?Q?y04qgDVaFlTIX5PMiLuLQk+1Ru5JDR7Ff6fe3ZdArMueizNH9xUx/gEEiHqe?=
 =?us-ascii?Q?wpyxxPhJC/sAHsAqqERuy+YV0HWrwvu2XiKtmeqE3y43sLKRx7xeru8CTlMf?=
 =?us-ascii?Q?wRlRux3vCsgl+b4gHD53qWca6Z4BIi0FY83KPc30ZLUWPvDL6natYiUgsGXW?=
 =?us-ascii?Q?EgK9s54q99UMCImfpAoAtV4RQ9qjng/mR8a0aGk6nwxKp2dNCd2BFlI7yM8J?=
 =?us-ascii?Q?1egH5qawGxguh0YdXHi7HBwnzGEIeQ58V+5nN/MnDw0X8S/vh9DwH0b7OcvE?=
 =?us-ascii?Q?t13L8PxsnUbuuivpXj4ftML+zvhofrrfTucqa40cx94pKtW5mSAqZgipvmUF?=
 =?us-ascii?Q?Hl3bfOAYmEnGOIbvzIjzQUNBlwHYswLLpePavuLDgvgReRwPMzZbhEMh4+Tq?=
 =?us-ascii?Q?O5noTq3cq7i83Vo2M938LQIU5eK0pwXM/CqhahItBkrxLvuj3Mb94oE0YkvH?=
 =?us-ascii?Q?dGM0ywcWO+M+JFrk2kPUg+aQkp60JdRgBFTiMakhrleedUAFeddxPF14S0fb?=
 =?us-ascii?Q?4PkJLR4jyRZ95aJIsnlrUzkRJAG5vusyDc5wEfKtbaVOSLh/eVPmkHUeqtKT?=
 =?us-ascii?Q?i0yPSN7RefCkTTF6EIXExo1oVmiN7sQJ4/7Bfm7cpd/zsl/64186E/CX0h7Z?=
 =?us-ascii?Q?NMxjx18V+baAp1d2uQMMv9bW5sobQscsTQi1w+cQL7/rcnCQnTkb7BHnHtjd?=
 =?us-ascii?Q?N/zpKKH845lv8QM1dl2Wo2xOTNY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba30bb1-02fc-4f4d-c0d4-08d9bfe6d57d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 16:20:41.5645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixUYsUONA14cXqinjsXESbdHdYCChpt0aiGjL78cm9DWsU1l0oGe+V4sBljTBt7GVP84x1xrGR4jgrb6IYdvK5/QCn1wJieCjOKVy9qdIV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5790
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10199 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=851 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112150093
X-Proofpoint-ORIG-GUID: Y3LbarhV4Pkr6bW1lLX2HhnHDlDGqKK2
X-Proofpoint-GUID: Y3LbarhV4Pkr6bW1lLX2HhnHDlDGqKK2
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Dec 13, 2021 at 01:05:43AM +0800, Coly Li wrote:
> +	/*
> +	 * parameters of bitmap_set/clear are unsigned int.
> +	 * Given currently size of nvm is far from exceeding this limit,
> +	 * so only add a WARN_ON message.
> +	 */
> +	WARN_ON(BITS_TO_LONGS(ns->pages_total) > UINT_MAX);
> +	ns->pages_bitmap = kvcalloc(BITS_TO_LONGS(ns->pages_total),
> +				    sizeof(unsigned long), GFP_KERNEL);

BITS_TO_LONGS() has a potential integer overflow if we're talking about
truly giant numbers.  It will return zero if ns->pages_total is more
than U64_MAX - 64.  In that case kvcalloc() will return ZERO_SIZE_PTR.

Btw, kvcalloc() will never let you allocate more than INT_MAX.  It will
trigger a WARN_ONCE().  If people want to allocate more than 2GB of RAM
then they have to plan ahead of time and use vmalloc().

regards,
dan carpenter

