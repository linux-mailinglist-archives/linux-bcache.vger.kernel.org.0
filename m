Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54375749245
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jul 2023 02:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjGFAKe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jul 2023 20:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjGFAKd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2023 20:10:33 -0400
X-Greylist: delayed 25175 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Jul 2023 17:10:32 PDT
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3F01993
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 17:10:32 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id B3C5640556
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 17:10:32 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 8A17940623
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 17:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:from:to:references:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=k+AFx0GNPebC
        2iGHT3DNNJotQU8=; b=LNEi9t6sS9cBpf8RsibiBEr7qGHY8Ce12TXukCIUtayo
        /iGiLz/7DY2FoMamOo2b4Wjba7rIisHV6wat8uDsUxmEKc4y9opBT6bwk0Sma8rD
        G1GEz+aC6nPyTvt94n80iBLMNFopapmLr8UwGxpqydqk123LqYfZStBy/YLzIa8=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:from:to:references:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=Q1i0nu
        yMGCt5vIfW2zEB0ahSQEDCydySUZEB9MHnJYCufexwP5hCNdqqpwU8W4+yLE984l
        P90LIJtpRTHUzH8+mkIlctG6ZeI7P7gVo6Dbra6K+/JCJUH99kQc1WUwI+haBqW2
        fB74YLOsuZSbxyysjKbB6DBD2sP+wo65cLj9A=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 7DE0440556
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 17:10:32 -0700 (PDT)
Message-ID: <c0189513-9078-c039-fab3-ce9231b0b5ef@fatooh.org>
Date:   Wed, 5 Jul 2023 17:10:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: bcache device stuck after backing device goes away, then comes
 back
Content-Language: en-US
From:   Corey Hickey <bugfood-ml@fatooh.org>
To:     linux-bcache@vger.kernel.org
References: <04a56e2c-a89a-5cb5-4fc6-6d445f3ce471@fatooh.org>
In-Reply-To: <04a56e2c-a89a-5cb5-4fc6-6d445f3ce471@fatooh.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2023-07-05 10:10, Corey Hickey wrote:
> At this point, using the backing device via bcache seems impossible
> without a reboot.
> * original bcache device is still active
> * can't stop the bcache device, since the backing device has a new name
> * the kernel won't give the backing device the old name
> 
> Is there any way to recover from this situation without a reboot?

I found that there was still a dm-crypt device active on top of the 
bcache device.

I did this:

$ sudo cryptsetup remove backup1
Device /dev/bcache1 does not exist or access denied.
Device /dev/bcache1 does not exist or access denied.
Device /dev/bcache1 does not exist or access denied.
$ echo $?
0

After that, power cycling the backing device allowed it to come back as 
/dev/sdi and auto-register with bcache.

-Corey
