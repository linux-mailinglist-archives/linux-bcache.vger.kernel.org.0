Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE21687CE3
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 13:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBBMJB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 07:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjBBMJA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 07:09:00 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADED783E6;
        Thu,  2 Feb 2023 04:08:59 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B4DD65C01AC;
        Thu,  2 Feb 2023 07:08:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 02 Feb 2023 07:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675339736; x=1675426136; bh=ksXAXLaoNg
        Xc9vmkkalkhvSu+CMhyzY+9HFqmojr6HM=; b=Jb816Pi0WNkwFrupkherrxcCSW
        7/UpRt2+D4EZlHeBEpBHTfvxfnvxT6O39Iib5xDpfaaPIRO51CAE9MLAlbQU5mv/
        aMvEC5NrsCN2+a7gL9+K5eZCMGk2Ae/3kuRUlrvtyKZAd2DSpady5BifG0fVnDcR
        T//hURn/CQYXhtUk9h6RsKU/gBqjN1OpDrIGtqitiHbxNxUDgZhgmzBWcdNC/QtM
        oYYvQiOP/2xNr/K7slEL4BAkCLFJ1eEQhw5/tweSUH++zlU0CZ22m+OSL0vmsNOz
        ODLHQ2jFzb8KfnsIk2UjX1moECEg8CeLYu0HHOGDRsT8++YhG5aYD0pxIfkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675339736; x=1675426136; bh=ksXAXLaoNgXc9vmkkalkhvSu+CMh
        yzY+9HFqmojr6HM=; b=VGwKBjId0WbfYOQc6s1WEA0nHU59aUWEvvb1erkYoyXM
        D5AqQsnEOZ5fG8tClKfAV3OArYHh+kijFuNfJy5KZOGO+lF2lEuMatNtYhfkDHnp
        wo1yGCz35IMTDCaXX088EU8D8xO0XbB6MmcsVminsJ0sulBWgdge3B8I5OvAa6hS
        e5TzsRnLzihKJ/r5hP/himEhMlyY6czqxYWYY3crfKxqADTyUEojhwiXl6KUCzh+
        ulznqZ/BIPXQ+fiz1AgL+lfVmvaI2ihMROQKyGlFTLl5tmxlMqrDdt2xjGEPNx3B
        ZDR76/od7qZ8kLfn/bIwjTK1IGsI6HvetlOlgCqOFA==
X-ME-Sender: <xms:2KfbY_w1FHHKIeVDreTcmawS48K3epWOHnbqziXmN3MaSDouymk0Sw>
    <xme:2KfbY3SAYeLxcB1xfYbTi6V95hrNLnLl8hlo0kTrbT0R9mmNOB8FhdeHLqmAfe-Li
    WmVETXZNlbX0w>
X-ME-Received: <xmr:2KfbY5VBPPee-aipKpqsymTPpSPNkqPTXI52B8aUpjyD9wG3eIA4H1CMmsiXtIVxU7SynAb6XJtpfjNnenBnl0cNjovjGspBc57z7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeehgedvvedvleejuefgtdduudfhkeeltdeihfevjeekje
    euhfdtueefhffgheekteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2KfbY5g201cAWw73F-E54gmKiHUfLvQ_0H80voDGOC4xHlNpEkOlTg>
    <xmx:2KfbYxCTXoi9XqRaohqMPhTwiqmhDPjXl95wev5PrOGFAXqOUt7PHg>
    <xmx:2KfbYyKaC_z3Zv3E_CVFkbTIgHn8DjFKW9TYyY1WmwtliGq7M94WtA>
    <xmx:2KfbY5YkpfnD3x8Aj2HywcIXsqAY0Bh2RG0rDaLFU2QOPsRvm8fZ9A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 07:08:55 -0500 (EST)
Date:   Thu, 2 Feb 2023 13:08:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     colyli@suse.de, hackerzheng666@gmail.com,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        alex000young@gmail.com
Subject: Re: [PATCH] bcache: Fix a NULL or wild pointer dereference in
 btree_split
Message-ID: <Y9un0/BnBoe4B4m1@kroah.com>
References: <20230202110543.27548-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110543.27548-1-zyytlz.wz@163.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Feb 02, 2023 at 07:05:43PM +0800, Zheng Wang wrote:
> In btree_split, btree_node_alloc_replacement() is assigned to
> n1 and return error code or NULL on failure. n1->c->cache is
> passed to block_bytes. So there is a dereference of it
>  without checks, which may lead to wild pointer dereference or
>   NULL pointer dereference depending on n1. The initial code only
>   judge the error code but igore the NULL pointer.
> So does n2 and n3.
> 
> Fix this bug by adding IS_ERR_OR_NULL check of n1, n2 and n3.
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger.
> 
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  drivers/md/bcache/btree.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Note, there is no need to cc: security@k.o on any of these patches that
you send to public mailing lists, as the development and discussion of
them should happen there instead.

thanks,

greg k-h
