Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED5C762C43
	for <lists+linux-bcache@lfdr.de>; Wed, 26 Jul 2023 09:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjGZHBI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 26 Jul 2023 03:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjGZHA2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 26 Jul 2023 03:00:28 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A88EE
        for <linux-bcache@vger.kernel.org>; Tue, 25 Jul 2023 23:59:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690354775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uv3CnAnXFWAb1Qfc6DYGZ2zStBaDmHQahM10yM3E8NM=;
        b=jD53phpyWPV1m6lZJFSij23z5l3BtMZ3Nm78UJiIwyWe54WQrTuB+sE65oVwbOCaOC4LVW
        IQLhspnZBS8xdLdXGppCnRW57Ryb0UwsUR0bMOKoxDhTEU7CwRK7a6TaSyxs47bGtrMftD
        EYhZrEwmNT7OG6AMmxQHn4AvJzBEbco=
MIME-Version: 1.0
Subject: Re: [PATCH v2 14/47] nfsd: dynamically allocate the nfsd-filecache
 shrinker
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230724094354.90817-15-zhengqi.arch@bytedance.com>
Date:   Wed, 26 Jul 2023 14:59:06 +0800
Cc:     Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
        tkhai@ya.ru, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, djwong@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <864F467A-C237-44F9-9271-945146948336@linux.dev>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-15-zhengqi.arch@bytedance.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> On Jul 24, 2023, at 17:43, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
> 
> Use new APIs to dynamically allocate the nfsd-filecache shrinker.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>


