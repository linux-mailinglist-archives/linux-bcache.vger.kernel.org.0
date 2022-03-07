Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA84A4CF376
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Mar 2022 09:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbiCGIW2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Mar 2022 03:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiCGIW1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Mar 2022 03:22:27 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B9262114
        for <linux-bcache@vger.kernel.org>; Mon,  7 Mar 2022 00:21:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1DD90210FF;
        Mon,  7 Mar 2022 08:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646641293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NsfuWpLQ//jrSE6qjYLCowPHH7XQ/ycUvGV+pFQaK/Y=;
        b=tvu5cK7ntetPAK3dAlBQ3XED0+/+RlYoRinQ6GilGzMXpXvF2qwDmwCzZG+GGkzUjlVSse
        lekw/GyaR8mUyP6DLOlH8z3e/IdpAUYRuWzdI/tqqcLobHmjVPVpTKYOWMYjaanCUu8hI/
        Uj5ZlZtV81hu6mumCBFB4GMGJLNGjRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646641293;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NsfuWpLQ//jrSE6qjYLCowPHH7XQ/ycUvGV+pFQaK/Y=;
        b=a56buSjthDiJFCAPKQgQXck3HCV7d8ttuJYb0V4lkr6UBxrjDaKInZ6R9bOwb+8jSj+J76
        mVAdQfYq+A9CdoBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A1A4613A04;
        Mon,  7 Mar 2022 08:21:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /yzmFYvAJWLQaQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 07 Mar 2022 08:21:31 +0000
Message-ID: <2c6244b9-249a-3379-31b5-f16b3d0cb162@suse.de>
Date:   Mon, 7 Mar 2022 16:21:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: bcache detach lead to xfs force shutdown
Content-Language: en-US
To:     zhangzhen.email@gmail.com
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
 <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
 <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
 <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
 <055868d2-1363-da7f-ff4a-d232884d35b9@gmail.com>
 <81a09386-1c4b-810c-a387-c636a0c3d5a5@suse.de>
 <bff3b87d-d8e7-1395-f431-445d98716906@gmail.com>
Cc:     Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org,
        jianchao.wan9@gmail.com
From:   Coly Li <colyli@suse.de>
In-Reply-To: <bff3b87d-d8e7-1395-f431-445d98716906@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/7/22 3:56 PM, zhangzhen.email@gmail.com wrote:

>> >>
>> >> Hold on. Why do you think it should be fixed? As I said, it is >> 
>> as-designed behavior.
>> >>
>> > We use bcache in writearound mode, just cache read io.
>> > Currently, bcache return io error during detach, randomly lead to
>> > xfs force shutdown.
>> >
>> > After bcache auto detach finished, some dir read write normaly, but
>> > the others can't read write because of xfs force shutdown.
>> > This inconsistency confuses filesystem users.
>>
>>
>> Hi Zhen and Nix,
>>
>> OK, I come to realize the motivation. Yes you are right, this is an 
>> awkward issue and good to be fixed.
>>
> Hi Coly,
>
> So you will pick this patch into your tree ？


I need to look the patch firstly, could you please post a proposal patch 
for review ?


Coly Li

