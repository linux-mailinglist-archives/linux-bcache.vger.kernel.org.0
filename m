Return-Path: <linux-bcache+bounces-679-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3B790F3A9
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 18:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59548282E99
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 16:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A4D1586C2;
	Wed, 19 Jun 2024 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RwqQRz67";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ixht4UpH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88B0152787;
	Wed, 19 Jun 2024 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718813039; cv=fail; b=UGhQ16hcdOXbGDsz+P/I2MAwGZ5anDqEYfcyJd1gBzRQFleR39TVt53dA9nqrdtMD6kUSdR3KKN37E260tc4g7poY1kM/xfc42P6OoOlwFC/khbRceC1Z02otICtlFY+pwyTIC9B/kl4J5e+OiiHS5ZcevePewr9vCqAK+6HGlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718813039; c=relaxed/simple;
	bh=OC90+sgQOjqJb0+gkledryNcHMeeVp324e/UPoxW5bo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MtrDw37tuCeb33ZQJCXeyeTZ3zgq1Om6XTOqmuVOhfo+AUEfQ/65Jdw6kVfUp8d4TY9WJo2y/f84F+0/MQvK6oSEcHbinlWYQ+Ru9I/jS9tlD+kiTiiWk9WKFSkRJRI0t6HX4OIWWs5ngrgTvyXLq9o9hqV3RP10JueGWaPwEok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RwqQRz67; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ixht4UpH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JFBRnq026171;
	Wed, 19 Jun 2024 16:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=jZz6Z/2aYj5vCV
	d71aSVK7EvWm1fbfvst6zPsOFVDnQ=; b=RwqQRz67169WpO8n7PrmsW2+kAcVgq
	M3oHmWtlHcNHbXWi28lb8NHDOfGlHen1ZnPTjwnSFjouEBlTaXuO0oTLPZg5rR7q
	0lcovlaRHd2H+Art8q0QwEgmjFjr+wqRG9OyWu9ghgmfg4nEWn6H3kXJGQURAqAM
	cwVaWiPXFbcGgPU6g0RdL90l5b0564234LUCrLA8nUj/s/jV8ToCu1ZqrkdDEFek
	q4EPQkHG2cATfz9b7Sv6Q3dN3TvkpSGyURyr2UWQnLYbrEf5/I801+NhaeF895ze
	FzUXEdr8Xdg2X2RQcjc1ayeqdgE++HZtgsKex+8VwSefxs0PUAi5rogg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9n9kcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 16:03:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45JEaOsG032918;
	Wed, 19 Jun 2024 16:03:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d9fkd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 16:03:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUZOrmx3AFqYx4rYIo+qYd1yTowBTk78EuuqjxcEMuWTAGH1rYPgrZY+N6FGOdUSMat6hewBfn2RW/FYVSsf3R8u7QDpb555lezk94JfgWDk+kwcHNexOZOJE+o/MMDJ3dairJnHnd61pIvDniWBgjcFPR7PSWMSZBBYU6xEimHdwuEvuYhwKLigGr3lqZhpCbRJW6HZDgd1GkW4jmouW9LH0vPo1s6ic0USyrjcy7Rss/MHjWh7Nib8pAnK8XfRmvvgT4BNaJxauJgcYMJ3VF4BkdPTAc7QEkHmHj/tB5XaVzujkQbXnQjDIRCC5JVR4FfXQSKlisILUnAvsN3HHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZz6Z/2aYj5vCVd71aSVK7EvWm1fbfvst6zPsOFVDnQ=;
 b=TCzGjSEFhjAf2tm8uAHbpFfZd+oegoK3EeXqkMGw/UyvF9ewEua3Me9qUAX5AciCwvnZvCYj3GVXh1ucQXyk5QrfoiyIDWKZ5iNww7U6IEK/0Rd1UhmV7hzG5pG8yzAzWmvcbRkGw5wQdneLHoWwgPooeem1FBorZZIXT6ZTfQfhEieqsPSG2RvpI8Wfi1EzucfSBugKOnBKBOCi5adE4zL6Ac5wv5jLnqtQ7SvRW8xK6JyGl00vAJDvDtNnAChdq2k21jyYIvs8l5a6vOQ+mhWQhOFb/a/73zxxpG5xWCoCVQnoa93hBMI3tWiMelsEM8Yy+FdeTDryVVMfLWGF8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZz6Z/2aYj5vCVd71aSVK7EvWm1fbfvst6zPsOFVDnQ=;
 b=ixht4UpHqvMX8ROvWhhRiNEkhl1ZwOn7e3K51dZeAZZ4CiR7sJbz7hPU2FhQzrveD1BPIiak5NI39zHFyWfBDwaNxsCbn78+I2pyvfPdA+1obeanSIPTVPVCPwl3Rp39EALZXAPhqYD1N0yNmY+W66aorssyEObuRkWelhSEooo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5866.namprd10.prod.outlook.com (2603:10b6:806:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Wed, 19 Jun
 2024 16:03:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.019; Wed, 19 Jun 2024
 16:03:47 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org
Subject: Re: misc queue_limits fixups
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240619154623.450048-1-hch@lst.de> (Christoph Hellwig's message
	of "Wed, 19 Jun 2024 17:45:32 +0200")
Organization: Oracle Corporation
Message-ID: <yq11q4sq5rq.fsf@ca-mkp.ca.oracle.com>
References: <20240619154623.450048-1-hch@lst.de>
Date: Wed, 19 Jun 2024 12:03:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5866:EE_
X-MS-Office365-Filtering-Correlation-Id: 195024ef-55a2-4c30-0315-08dc9079673b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?pDrri9vdSsOkqRLhivExoGg1Qbeht7b2fxIDL7LPHvMOuQZzy2rhpIzDOvzx?=
 =?us-ascii?Q?jewJYvvEArfaTfQzPPtqyHanj8keG/9nW0O+CZP/AXwD1kjPN3Vtie6UWL0R?=
 =?us-ascii?Q?DpcWrxaMZR+i47MztWxe8JFi5XOK9P4X2be+nDQpAU1thP9610FElwmq07YW?=
 =?us-ascii?Q?e9THNcX+1MeNKVrK6KBuUyR+9ZSv2hCfPMZE3o8ZQItrGj/L4TLjNh8lTw+x?=
 =?us-ascii?Q?0+kxKXqlzG+fNJx4MiglefQPpJXVu9mcOGzZJj3CjOzDIivsg8rTNXemVF6d?=
 =?us-ascii?Q?Js9NohAAq0e0P+kE4MIKUw4pYDXW8Y1peKhFVhHPT2lFqb0I7Y47eFGU0R4z?=
 =?us-ascii?Q?VzaDYk3E6wIP/7pAT0LLfrECCHq7DhRtL7jHyMqIxtWCIwkSF8WL4BM6jJDr?=
 =?us-ascii?Q?v5rGlIx7l0lwXpmzxw9yxeL1V/PF69tV1dQQ36Hdss5Xap2uUW1iNlkJK2rt?=
 =?us-ascii?Q?gLTG1uBZBj5WrNg7nQZANS0T21g0USpwaL8W8C5cx+Dzk+drWKDBK+uEl8bF?=
 =?us-ascii?Q?Pn5y53h+H5DOBzxKrXVP1cB0htHKQkzhpo7HBjwvmJDLpczAarBg5jZYJgD7?=
 =?us-ascii?Q?/ZFtIKR6Igcq+TGEMjH2iMm5nzP6HYzi4/DePXd1V2ZgZgV1nHWHq23m3pR4?=
 =?us-ascii?Q?eaiUlFnCJSk9Mi2E1vYvCDHe9iJhxpuIFJypfGIAtfK0DYESP8CHEDahnWm7?=
 =?us-ascii?Q?Jurom0p/1HyZ/264mdDaPc9NYxJSC8GaKIYEZakBwMTc++YZpdk5wJydBs7c?=
 =?us-ascii?Q?VmynjcjqBTGC56+pXKllaQgwvGkOlUN1Y/Z5pag9ggb+BUW0033/fm14j2ds?=
 =?us-ascii?Q?S+k9Y/dY2QVnmIxs18s1UtGUCmLDEdm9FZHZYBuLeHtL+HDsQP1JgMpBzvaN?=
 =?us-ascii?Q?VUfpaA7gzVsk11lwIKq1vz0+USIPfDNwYiEEtDXYu1PiSONOOA/nu2KHiz2n?=
 =?us-ascii?Q?eT92x5hv8qU+Bl/ydUu++tvg64K/i1zH3CM7XDmsaRFNr6SH1SbUt3HaqMO0?=
 =?us-ascii?Q?1MLNvOA5tjm1kyd1ro8I5a/UfUjpPWhxXKMsMWX+ckrEtAs0VfpMPCVzNBgg?=
 =?us-ascii?Q?CCPAuALPIEIZDtE+U33WaoDHh8W+gNJcvwnhjCzyJL/Ywn8U8i0jTysAODsa?=
 =?us-ascii?Q?2rgRFTiJ66LzgwvcImjhJ4REzObqi3mfxTFzRJxXRUiq3GPwGbf8MQ90dWNm?=
 =?us-ascii?Q?YwAUe83HQn4YcGYdZnQ82lNYfCeP9ieV4Zv5+srMbjfzTAoP7dXJNxQ+LJFm?=
 =?us-ascii?Q?A5tqj02qfljddtPwjpxIL6GOqKQdkc1RKCR/RrL1s3aS+IN+WU1EedgQu6WJ?=
 =?us-ascii?Q?aJM=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?d/Lppai4yNg8V0Fn6UnoD1i8vr4cOl6Tui76jBvm/99QABugbZxZE1GH/lCw?=
 =?us-ascii?Q?wZThR70FdHKuPyeY1zOL06I/hvS4EbfVEQTNSAVH+FoAYk8otrtUTcCAe/bE?=
 =?us-ascii?Q?wO+tY/cZBJmjBQXEH5aNcXXRQtgvSEWTUA7T8egAJnupyNKmuqFSKLp1Qi2C?=
 =?us-ascii?Q?AUofaeT0G9Z5fxM/3LsEZB/VP9t5LEp3lQfCTrt8w0dSXJyvkH+xZCzg3s9H?=
 =?us-ascii?Q?LYeXUGc9GF1JTFaY5iadW06kYgchRUvLQHJYOgZfzEwM0LF7rrjAj4VZew6Q?=
 =?us-ascii?Q?G96XCroW2v66EL6gy8TERq3feAfgqmAIXeaprZ8OC0W0kCg+WzX3dL4gm2bo?=
 =?us-ascii?Q?grAAF9Sg0txDT8OJYcpbwVRbAiTMSumjPYTQDCj8G2N6O/LFya1zznqq8qar?=
 =?us-ascii?Q?aVhcLVlJSUYpq3K3lVF0TjjfIiwJL8hUbCIj3q6yHwKJFm/2JeW7zxlLytpY?=
 =?us-ascii?Q?MFqmh733bvROMzPliT2UmBxC5XgfxT9t/iYjJZTPe+froq1L1253HLBIP1Hb?=
 =?us-ascii?Q?Q9jt0i8PuYnODkDVz2K09/FtmvBeLLamlzCa/ybNjjDnH4D4cgn5zem1Md/7?=
 =?us-ascii?Q?mOTV9xy8V+xK3lnTfPNMmdbA69e0rD67sPpBYPHjhlggnC0DtonjS/geHX1h?=
 =?us-ascii?Q?QlrjLBfmCBUhnFYyck+PKc0KKThC5gy6cRV+LoRrxtvV+2X5KO2kjOr183tQ?=
 =?us-ascii?Q?g4nvnGnFSa3vj3nT3A0rfK10+JPzORwY90mC4JRRGJk+3jHTXSyz93loF9g9?=
 =?us-ascii?Q?eE0oKkKo+kAauYxboCF+B/1Xcp5L31l7+M2LydwgMY6pe/Me4vp1LoSdmyws?=
 =?us-ascii?Q?gX8M78XTz0aO+Cirr+oXFWIpiPhuqI8MzoJvWEivjUpl0wiy/rdj0nlQ9Hu0?=
 =?us-ascii?Q?8t6aahq/C7gr6tkGLAhjiGGVMv5JI+G5zME78/eaQVMWP9XU4BU9b4URUOPN?=
 =?us-ascii?Q?qI0XGDhJR7msG36eIUSqdyh/O/bOlXDaaSdY24+9B8m8KA865s0KWSbW1SgX?=
 =?us-ascii?Q?gQKCUmxRX48o1dn07wg7CFmzciVCmIBS/l4+DeXJqRy4yI/YCpyf/bFJ3hBE?=
 =?us-ascii?Q?o6nxmnnT09XwPp5BZmcAV/wH3ppxEYam15c4uJD8G+bTHsU4cOezvuxiS89x?=
 =?us-ascii?Q?IeDxRobpZwLurJR1sCRUuPNsDm/5STINeFZP5irEu20fDITOrlZiXP8kXoBN?=
 =?us-ascii?Q?tVcri+l96Mhy9PAz43LBomsplPZlxiWclfZNTUNcGxHatEEj02nZVvcKn2Dy?=
 =?us-ascii?Q?3ImJ6OBPIdL46maP+QddaAogAcWJdsvPbABDy+JYilnmr95ElxGhpTHr7l8d?=
 =?us-ascii?Q?N8qoLa7ad5clf9nHt804BBAEL1jn8c4zDoO2OjmLh6iFSOSyC7zW+K/gqymq?=
 =?us-ascii?Q?b3lwzOGTgTu9vT684gZcSqa43GecboOwsIAGU/Sw/P1TMPoWmG2UJP4Oc4xG?=
 =?us-ascii?Q?+WMlZreuCTuSfRze9bQjCRTvA5KnwqkJzm+4qAK+VZEmMoKbiS/9UurF6iFv?=
 =?us-ascii?Q?pvSQn0TfxpNLBJMfvoTucvnkb5lkbZL4Ax6SBTiDWq5aciN7dgyTppBfZF3Z?=
 =?us-ascii?Q?rGJpsxV9sgh1gfxGyv3IlWj5JSnyd7Zy49hGFy7Y/Gn7DcJrKn/rzqYvppqc?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kUVDUV2/UOCMXOCpcJAN8G3PZx5QOZgji9DXr5kJfUrRv42qv4tvn/plhvJAEYKXMSh1BCSd1OMmO17hTZSWiVLS8CeFN+QnkHNCez2K7tZe60+sgbs1g1LfS0HYDFR2DrgekudswY1t3Zs9zoDnGF4TJWtetVQ9+NUTixmDf4KEnXqLV0/exAX7vNd5Qw4NmJVxAHG7rRQlFukxBD2ztH23VZs2qTI+QNRUPDNNM35Egzqsxm/JIV8sDdBEOn0d2X3hXhsk1d7EXzVCWmGJBE9cX4wIrVKFLtmiXqY9wcpKE75VKg0CtURT/nJyZS/w/3+9l0hUu7RcDnhb3k3ggC+JrwvMmQk4Nh7VoK/ndsB9oVSSIO1gt/5Ww96Frwkkqg/+5zdj6sBkGqa95zcxQWTXOY63vBlxSm2kt2KMR+k6GsnyoxojxG/mk0VeVyZRhhbb7Vu5pckJ9Bhydg6xXRbYeGmdAcVRCh4HAd4fVhx0pK7KsGsoo8gn6/1s9ToPCkGL8yjqCNPGWNGuyvIzpHyGCA9bx262Oqk4GQ1GzDtgletAMfkZ+ubKGfPOlL03FsWZDVbYGNoEXo+tcECYGb5Mo/4ozLbgMHQr8/GukaM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195024ef-55a2-4c30-0315-08dc9079673b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 16:03:47.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ckq/G5WhZzyimstuvphcvxCkH9gpgxmzK8xCnT1Mt7ISZ/VTIMnlXH0tisMCkDMKnJHbZhEpSYnBg6wiVt5xfYDKjyUrNB83bvoYMqJfBDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5866
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406190121
X-Proofpoint-GUID: 5yBRfaQq8K5F5PhHR-1kN0YPIY3jCGG2
X-Proofpoint-ORIG-GUID: 5yBRfaQq8K5F5PhHR-1kN0YPIY3jCGG2


Christoph,

> this series is a mix of a few fixups for the last round of
> queue_limits fixed that I had prepared for a rev of the queue limits
> features series, and a bunch of imcremental conversions that I didn't
> want to bloat that series with.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

