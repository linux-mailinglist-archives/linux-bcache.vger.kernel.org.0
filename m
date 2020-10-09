Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A42289BFD
	for <lists+linux-bcache@lfdr.de>; Sat, 10 Oct 2020 01:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389878AbgJIXAz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Oct 2020 19:00:55 -0400
Received: from mail-db8eur05on2123.outbound.protection.outlook.com ([40.107.20.123]:33786
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731374AbgJIXAy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Oct 2020 19:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J47ghNKx/MiKadtzhUQdq0ISSSH9lhLWF1KwMLRQMyK9hmOTa18qgaSaK1P0yECZJNjpmbiO2dFL0Lj++z/bMd5/Bhp3RXPytqbqbFyE5HhbKeZKZpgJAogd/Z6aGatj1xl2f2Dl7fAzj/jZsm4FdqbWBAy5sMJNcD9Wa2oJxWYV0geTtRP9gTA/YfWVWRiaZmsXCL+chbb4VvqcAabER833J8ffwITSSj10zT050ofyg2Ov9e8qjjEKaY5Hsh9pwTV/mDP5BBLOvOC2QLMYmEF6ETVRmwAOpnhr+6kimicXRUQNuu66h37rU43x0Xg8JxGiDc2f9/53n6bNt0AlTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QoE3DweM9BYLNqTICRTXACli0vPnR+qjpBCbNJ0eHg=;
 b=kKAthh8j00plNylDtbFJonQ/kiKTxjGqihv4AmgRrLZT2weQp0bRUbPHfx+mSKKIAmHouV+35m8ZbOcOBd4hgryw53jsacaheBMovhT1AIwcnN+NJ+uLx+qO8Ow+T9fJVSQp1wFlWNtEZ0jqGuL14bJfd5Rm4fCdqqDU0Jqb8/SIfooDrPjVjFeq7Qg3vM0zV+RdlVBa11q1dT7iLxWQWijL6d/IF49uXg7WL/z5P56EtG5B6fLRpXbF41cK2SFkP0P4PH7LnpF+eArM7PdKXaEj4LolQRIAz7Ab8hHMdEFA08uc5NtClk8cS/9Ns9hnCxNs4rwg44Po0aqTvHfhwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QoE3DweM9BYLNqTICRTXACli0vPnR+qjpBCbNJ0eHg=;
 b=bYXMHjQDQrKj92hskEpvj0jZAKhtktkFYiDbtrQWFgVelP2CnlNuVmCBMbuzW5QhZ4QlOErE0kqgaJ8nWMvh5ifQWKUMDHGif8taMLb1VRIK//B1CDpU/3r1oyaHQ6xabu3vTfk39xIp8nOnSfr9l0BHUr3M8W2XSaANyeeB64Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2260.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 23:00:50 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acf4:4f51:6c3a:8cbc]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::acf4:4f51:6c3a:8cbc%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 23:00:50 +0000
Subject: Re: [PATCH] bcache: Use #ifdef instead of boolean variable
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201009183447.1611204-1-alex.dewar90@gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <b37a5dd2-437d-65e3-f432-a5247d09d94a@prevas.dk>
Date:   Sat, 10 Oct 2020 01:00:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201009183447.1611204-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM4PR0701CA0019.eurprd07.prod.outlook.com
 (2603:10a6:200:42::29) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM4PR0701CA0019.eurprd07.prod.outlook.com (2603:10a6:200:42::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Fri, 9 Oct 2020 23:00:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d33a5e-9894-4356-20d7-08d86ca72a96
X-MS-TrafficTypeDiagnostic: AM0PR10MB2260:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2260D26E37EDF8E84C7BF0E193080@AM0PR10MB2260.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFYW8fmoG2gtVvoZLVJjul3hP+Y9ks9hmqvWAZ4AlrGJ9nYtpdJpZDqgdFpwj2/da8D7xz57YEGKyzwdjLbSrzbUHBIOuW5fTP6+pC43Z2igACC4c1/+NQHfxrYiMYj9/nKbmTEVXCqZLvJvnozEgUUk5S1QyIFyy2HIM5h01oWll/w9fBTqw1AD88deLxv9NngtvMSpbtdAOLJfeNIVI1OJqqG9bWfehQqfBeRXRZWz9nUhBTEuGrnHC777wH1cHEkGxA480ieBgvqGAzv0n3vHyL2YINqXtqkcMyZoEDuXtdz4eHCFuWp4gH9jBQEVTzRoHJR4yXY0TEvUC9nSgDO783DmqrsD6+0eKI1pcpJg7E7JWCFHWgWfa/XHZYFb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39840400004)(376002)(366004)(396003)(136003)(52116002)(86362001)(16526019)(8676002)(2616005)(186003)(8976002)(956004)(2906002)(8936002)(478600001)(44832011)(54906003)(36756003)(66556008)(66476007)(66946007)(16576012)(5660300002)(316002)(6916009)(31686004)(6486002)(26005)(31696002)(83380400001)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zc6awHjL0MK7IIlQUgxRBlJgog/TlFMwp/Oq7tttSk7RIzu6S0kXtSZgzPYNkyT5Cbs04heYNaBr+lvekhvnvStKgn2D3hCzkE2iGot5kn28J77hdmjPngmRpnAWtdrwqhAPQ+ZaZzUgBpQ00fwcgcCM7Ep+XXT5pmUu/1zgZSukVfVRVF8/E6p9DlJqlOn6Wr3xdHwa37aDQ6LPma674ddfDx34UPlWg7X+LQWl/npgLyWIIGs5gjJxn/62/2J6F0gnVPYKnvkATtyc8+C/D0Hq2ZHuyDPUkMiVbvEaSTptuPrtbBHdeOZc00W/zexkiTbfNrOEHwyhrxj9hYxAbZKCf8xEzDkcB2w0dtew4xD/KWJFp10rbbNrPlcjd1P/E1eHFidaHEcQmP7NCMCySZ2ryAavXRldFfhKYXGxq951LXMFWAcgXRc5TO7hEwK/1/pXwTjev9rff9glQp1Auy5KmL7JpC3XhkUyl1q15k7+oe/MaLeabTMK5XlGA8hFWqle4no3HvvPlCCGUWee9XMp2xOqc0QbYiRvYxAL3LOTdDpxuNH8RnevUkgWxxDBhj3PI6n9fTwGb+33AAYBOvJMTdNwoZV17sha1oGX6gn/16TGFEjrqjHA7CvEoEuPivoGbduEMDauPEBKNZoQuQ==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d33a5e-9894-4356-20d7-08d86ca72a96
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 23:00:50.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IGXACvDtcdpbhttqU7s/N1unz54ux487cjZsg8O83fvpbLZL3tGkZTJwJrJTv+ZYt/WIOVNHC+yWFRNTffC+ajnIDq+RwURp/+l0wTkWXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2260
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 09/10/2020 20.34, Alex Dewar wrote:
> The variable async_registration is used to indicate whether or not
> CONFIG_BCACHE_ASYNC_REGISTRATION is enabled, triggering a (false)
> warning in Coverity about unreachable code. However, it seems clearer in
> this case just to use an #ifdef, so let's do that instead.
> 
> Addresses-Coverity-ID: 1497746: Control flow issues (DEADCODE)

I think that coverity check needs to be ignored. The kernel is full of
things that are supposed to be eliminated by the compiler, but still
checked for valid syntax etc. Often it's even more hidden than this,
something like

// some header
#ifdef CONFIG_FOO
int foo(void);
#else
static inline int foo(void) { return 0; }
#endif

// code

  if (foo()) { ... // this goes away for CONFIG_FOO=n }

> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
>  drivers/md/bcache/super.c | 40 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 46a00134a36a..6d4127881c6a 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2504,11 +2504,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	struct cache_sb_disk *sb_disk;
>  	struct block_device *bdev;
>  	ssize_t ret;
> -	bool async_registration = false;
> -
> -#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
> -	async_registration = true;
> -#endif

If anything, this should simply be changed to

  bool async_registration = IS_ENABLED(CONFIG_BCACHE_ASYNC_REGISTRATION);

Rasmus
