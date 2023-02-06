Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317A368B934
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Feb 2023 11:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjBFJ7z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Feb 2023 04:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjBFJ7e (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Feb 2023 04:59:34 -0500
X-Greylist: delayed 311 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Feb 2023 01:59:24 PST
Received: from mail.render-wahnsinn.de (unknown [IPv6:2a01:4f9:3b:4ea6::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777848692
        for <linux-bcache@vger.kernel.org>; Mon,  6 Feb 2023 01:59:24 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6933F1B4A11
        for <linux-bcache@vger.kernel.org>; Mon,  6 Feb 2023 10:54:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=render-wahnsinn.de;
        s=dkim; t=1675677251; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:content-language;
        bh=21Gf12/tG7XJHAY6PLrc+O6AW7swme/IjEdbqGfjQy8=;
        b=KaGZpXSpicPG1sJmBYi5MvvS0/ILyj+n/5I+4tjRCS5u5zAkACHLkibz0GLagTOOE8qZqA
        wFah4Ffs6gmjMZ1gAcUIUMPYagNmDsag/SxhwTVH/oXv6rkmonVjKsjQL1zb3K808mk9iO
        RMqPQ0E3DVJrIwTDXnXirBT/FL6Y7y3fQgKZw1tm9/q3Un5cc70iHJB1Wy8Be6yhwqcN9H
        JVmL6pSJnYTprO7pNmBPrVIh+aVuzM0DxuuxxOClSV1Luz6YMc2UHMheq6agvtYKGXdntk
        KXJUNrqhmfN068NqIPTUAbMaK0cs90ni2d0S8vmUvjtXEzonmqlEuEnWOilogg==
Message-ID: <92a2df4d-3631-b669-c275-1f067ad72bd1@render-wahnsinn.de>
Date:   Mon, 6 Feb 2023 10:54:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To:     linux-bcache@vger.kernel.org
Content-Language: en-US
From:   Robert Krig <robert.krig@render-wahnsinn.de>
Subject: Can you switch caching modes on the fly during use?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_FAIL,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi. I was just wondering.

My cache device is a MD Raid1 SSD.
My backing device is a BTRFS Raid10 on 8 Spinning disks.


Everything is setup as default. Which, as far as I recall means 
writethrough caching.

Can I just switch the caching mode on the fly while the filesystem is in 
use, without any risks of corruption, or do I need to detach the cache, 
unmount the FS, etc...?

