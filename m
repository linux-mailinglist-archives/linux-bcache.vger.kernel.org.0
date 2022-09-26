Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776555EAC2A
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Sep 2022 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiIZQOE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 26 Sep 2022 12:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiIZQNH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Sep 2022 12:13:07 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2055.outbound.protection.outlook.com [40.92.99.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C77F39123;
        Mon, 26 Sep 2022 08:01:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmLZUD0cXhQ25HVCwKJyubrkC7WvYuAkLhQolpx4R3Uxke/Bpyg4xNkTAhcGaZMFpQc7cjgv7J3pJmZNVNm0YEZJm51x3gXBKV4ulGtDYqtc4GctwhMICkRv387YZ7cNPEQMEX/48la0QJtr2g9M2VE0jutFcUDnF0ssTiLH3YEM3jL1/y8QdCiqyAKBvhIKWCfhhxgWloMdOyy4NkfI0rQbT7G/DvhaSirWLBt6gnqQzso+iAAQ9R3JHj65qeuyUFj94erUHehu5k6DmHvyWkzUKECms7xbnrZNitGPGAD1wS61OHJ+V1Ysl2ojzIyUbF7KZBvs2IARQoJAy1kZqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PL/uBUVms+9QzCyE0OfwlVY6EVEcFls0NjAu923kx8=;
 b=i35OnqZCU5pj7E1gEzeriUuAL4NkB5drygNm3AuTB4/EOORIeNrJ6pwqnAfjBesqXKyi/lTobw+vhZKsWW7kTnMzhVnVQPkNBT3Hd5ggnN92SzcRzuCKzkhDmamAD9s5hsz5JBSnU3tqH03keVp/U9CIBZPdRPwvCKOFtu04KifENqmGv6HvG4ZjVvDB7mLB1Y5+JmY6lO7Sx8SiYJDhfyddUtYlDfY7AyDtFFFV4tESamWgJuCmM5BJ4GXqWooZKZi91+Z4wIaOdcJNJTWFbKXEA95nbrmz0cjJ3OTo+uj3Iqo6bpBNTZwLXQFvwkxHSqVyTnwQncKDfM/AzJuo/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PL/uBUVms+9QzCyE0OfwlVY6EVEcFls0NjAu923kx8=;
 b=CQfp5sUwnSnsT6Qe+LvLVDzInw17lx4r1oeMrgEGvYST6xBwFRr4lGW/cSd3lKKQAeHr56dNDJ9wykv0ZyW4PuAiNFFHTlCZnybLySLpp+GfPXwip7jjQ4FGlN+TmosejiYLdBBVz1fgrk9Yk7r99roUz9yyasBcUWkq+kwfA+7dMcCdwdYdkv4G6+IjdTUQlJqbEBDDSICfFP+x7auiZ9a4qYWjpmAEJvVPycazU4Cs/8pZXAs5kpVlG53AWsOf6GOMm9HiX3La1Ozoqwim4YDAlQQcupSdrjzkivo+0FSoUFElxZ4suuIqaPdfkT4J5rPfN1ypYZbZAMct2Dfu9g==
Received: from TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::9)
 by TY3P286MB2627.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Mon, 26 Sep
 2022 15:01:47 +0000
Received: from TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
 ([fe80::f093:ab8c:7e3:f312]) by TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
 ([fe80::f093:ab8c:7e3:f312%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 15:01:47 +0000
From:   Dawei Li <set_pte_at@outlook.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dawei Li <set_pte_at@outlook.com>
Subject: [PATCH] bcache: improve race performance of closure debug by rcu
Date:   Mon, 26 Sep 2022 23:01:18 +0800
Message-ID: <TYCP286MB2323ACFB89E58BE6A05232C1CA529@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [GEpU/+jqBe3ONKgB2AJD+PnffGJUhm4b]
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::9)
X-Microsoft-Original-Message-ID: <20220926150118.937036-1-set_pte_at@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2323:EE_|TY3P286MB2627:EE_
X-MS-Office365-Filtering-Correlation-Id: aa2510b0-9fdf-4096-cdfc-08da9fd00892
X-MS-Exchange-SLBlob-MailProps: dx7TrgQSB6eMXPOMmUb6UNBfYDG/cmLPbviPIoBhI1zh1SMo4Bs3NYN8QJDsk6eO0MFo/RLG5Oso98zcPoDRD8GNF2Pp2lgY/IjIPxQuJHW3cnqw/4OHnhwjoSRgOBkc8jAEyei80FnhDhtwXBpJgSnwmxaliWcWwTR/B9Y7dVZzq0b/qXU23KUtfVey9z4GkdNgyxDN4uRrxQ1dAk/mGUrppWazA2NXRIJSPT1Qd1WWUzDAozSMjvsUua4BTVK3lxYIFffyL89Xdsh6t4axUSXCoI01YNVKLeA7ZGUjx2rrnHjWSOtKXk7jpg9HVpO69IbTgRjQe0HFpkAw9mlJVj/X0O997zOZLiGHZkd00H8QnNglcx85/wuiQvYmF4yb6MQZvlwybje88xjurS0krlLPdarOw/J0KSVHc2H9nTYzG5qibRI+7RN36u/P/b37pKRzAeUsgV1dbgKXGDCXN2S6ugcsnX/MK/vk2YEiXRaPOeL8B0WhNsUFv1gwl6VqkKspHgvFnxYy36qFa1ytZV5ANnpSBkTCVbawC62hUuStUh6QoR3JI2WvqWiPJyNjM8qNciUfhgBRQCaCMdMYgkkOY1jDaS6UIGbmUZOTTBkmZlEc9bVat80goYIGKzWVOlD91tj4g8hLmDQARbxfzOnfi4Q4TKNHwpWq7qvUwlvTPMb6LLA6tlSNhWWcUpM8tsr9RVHSHAMtQaQ37vLxR47JyErNDLfLUGERMyNF9228qVTf86lMS+D671xgFqRx52p4Rfhdg88=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kbSX9q4vl2eo8yviE3z+8ve+P4zGJOdoOFr5/GKTMfaIkiPBgFSPm1KIGD2AYfzV3Z+H6RPCgozGYDo5uImQjPyYwjiejqKrWpnGnTu4QKyWyLY1J05R7omLcoZ3o5Py7pi+I1rrCG9d9ncgrkcDA5u+5IWT9R9RO9NzL42k+f2Les2F0mP7QojHFOElDzs/n8TvlYFD4scljpmaYb00DLWNRxHuOQHcCjU029ibGIWd7TpmYWuq6wQZZ775MsRnpdKga3IGC1KFFXSjZs9maDjJzBVKhcNViRdJIjkfTDnjUfK8rtCBjqd9ufcuixiXel+cDiydjllE0FMilqwE7hMM7QaZXmUKPgkFFcqN+OzFSiWd5HpX5mbz7eG+bx9iWrXENofTXGMkuRPoiP4cyfLvRHk/VmnQMWH6hHqDimyfnfoKhAjGlye/WMyJyS1kodajah3eawB6mVnxT8IFjsEgekcToiX+rcDGtKqjPZQxU3AUm/IaxJ6hHVpdFmw8LWOc3NfSdbzWFHuqcmzzOobhbY2lWQ+y7RU3g8OfAH2/fvCAgMWY6q1UZEklFRXxVxylTXeJiak9zNR9KsdbNMHcE4h/YKIJM1r8E+P3poDG4HkSHAes2AnDIuSQv3hF
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HgfMjepfjCoEnipQl7a10OzeSHFrlVuKuzIrsBvWiBt31hpU5k5algqDyiFW?=
 =?us-ascii?Q?mxxOm3N+nPDrfdBiqYzq3nIiG3grW0acxbK5mj8JS3VnRpgDUbymxtZro2Q4?=
 =?us-ascii?Q?jiNSqZGT+V7s+40tWAC15ksxXsTAoz/Dvi69c/sWaKExSGVGNlfumJU5BrJC?=
 =?us-ascii?Q?f1noFjUHY43cVDH/9m/vS4nERYSLxoSqNnCGd1s13ZjF1xYuTSaDe/W/SzVT?=
 =?us-ascii?Q?MegCVROSQ6tcp8wbg9UeLd3KMq9BX84tHEmbmuL6kzdcgCNpkWkE51G7EFf9?=
 =?us-ascii?Q?MKqO4h0xBS6GJkjFfyQBzyMjX6tmOddiK7fGhuvUcUH2zAQmMfLf5fFuKald?=
 =?us-ascii?Q?ygYolqjyeFMUL9y+soXw0xPsiYTiq09mTlyflDBajjWRjGSs4M7A7l5JZh5w?=
 =?us-ascii?Q?uhWGiDrFs4ooV1JoITeP/ICj1s0iMx4MicNLkjQzzqOzEviLZbL4p7g/7vge?=
 =?us-ascii?Q?0PXoG1bOuRCnkmh57L85EQmVM86LNuirKki1PC2AXtUZVHXn1TXDjgNO5YUy?=
 =?us-ascii?Q?3tvgfKIxneDozNqyNV0S1b267YJXOEjOhHOEScXPLaJ3bOQUdEt9U+UtbiZl?=
 =?us-ascii?Q?FeopqnFq6GT/eC7hLHqUc4dB3K4/T05V8hc4RZISLvveatqIPgxyDHCjFEHQ?=
 =?us-ascii?Q?kSVKsOIzi8T8YOsHLp/mJWy32EOpsjZ6TQ8p83wfnDsAfvDHecWKep8LFQNU?=
 =?us-ascii?Q?Ao2J2oKQJBYdBpHAkoIw37C+mM3wwy/WncvGf1sKqbXX0Q0V6bnIB9M4mRtu?=
 =?us-ascii?Q?QY9xNqyb1pzE7+rG6Gbf9OuDMA8ej2GxMFponaHwXdv38UXTvFSF15AW2A9q?=
 =?us-ascii?Q?r0nJWKSlLUS+0R/78K1hHeoxr6aMUIxQsXgpNruXUjJNlFOXzJ654hBbOf+s?=
 =?us-ascii?Q?I5/GNU69riULIzh9ZjozzNB5kL+lyRq89HLoQeztUnCeUGBYnmhAvB9vH1db?=
 =?us-ascii?Q?ZpYSep9oWHT9aeeivaE3dPiI2lQEcoPTc8duF+8V05OUOEeWBb95d6IEo7wz?=
 =?us-ascii?Q?0pBdIA3G0zw5xEx7mrEtr0nWXbjVb4CS1noDXtaVbvY3WB4yMQXvtn6uVF7M?=
 =?us-ascii?Q?HSj452mGHPovvCuQaCTqt+Tr8j1UsYYr2luXYF/PbYtKnk4IVtlZ1hRCQJdn?=
 =?us-ascii?Q?yAOyV9D3B8XUHZhqP2ljVtd0y3JBT+SHRN9Wv/N+Q8PnH0QXO4Fi1AIlAYC4?=
 =?us-ascii?Q?ZWYuBRKWyqEzd6trPnm30vV/sZo7jTgPMh5q57Roqhmqb5PN7aUTQ3ewUIbF?=
 =?us-ascii?Q?/+CLjqUpt+87LJBMyeek8+aXXlHgPB+VmT+6Esn6Gw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2510b0-9fdf-4096-cdfc-08da9fd00892
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 15:01:47.5023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3P286MB2627
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Closure debug system implements a closure list which is shared between
readers and writers, and a spinlock protecting the concurrency access
on it, which means that all readers and writers are mutual-exclusive,
which brings overhead to performance.

A rcu-based lock is introduced to solve the problem.

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
---
 drivers/md/bcache/closure.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index d8d9394a6beb..b019d6338589 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/sched/debug.h>
+#include <linux/rculist.h>
 
 #include "closure.h"
 
@@ -141,7 +142,7 @@ void closure_debug_create(struct closure *cl)
 	cl->magic = CLOSURE_MAGIC_ALIVE;
 
 	spin_lock_irqsave(&closure_list_lock, flags);
-	list_add(&cl->all, &closure_list);
+	list_add_rcu(&cl->all, &closure_list);
 	spin_unlock_irqrestore(&closure_list_lock, flags);
 }
 
@@ -153,7 +154,7 @@ void closure_debug_destroy(struct closure *cl)
 	cl->magic = CLOSURE_MAGIC_DEAD;
 
 	spin_lock_irqsave(&closure_list_lock, flags);
-	list_del(&cl->all);
+	list_del_rcu(&cl->all);
 	spin_unlock_irqrestore(&closure_list_lock, flags);
 }
 
@@ -163,9 +164,9 @@ static int debug_show(struct seq_file *f, void *data)
 {
 	struct closure *cl;
 
-	spin_lock_irq(&closure_list_lock);
+	rcu_read_lock();
 
-	list_for_each_entry(cl, &closure_list, all) {
+	list_for_each_entry_rcu(cl, &closure_list, all) {
 		int r = atomic_read(&cl->remaining);
 
 		seq_printf(f, "%p: %pS -> %pS p %p r %i ",
@@ -184,7 +185,8 @@ static int debug_show(struct seq_file *f, void *data)
 		seq_printf(f, "\n");
 	}
 
-	spin_unlock_irq(&closure_list_lock);
+	rcu_read_unlock();
+
 	return 0;
 }
 
-- 
2.25.1

