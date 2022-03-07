Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84824CF43D
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Mar 2022 10:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiCGJHk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Mar 2022 04:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiCGJHj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Mar 2022 04:07:39 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D74160D9E
        for <linux-bcache@vger.kernel.org>; Mon,  7 Mar 2022 01:06:46 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id s11so13132308pfu.13
        for <linux-bcache@vger.kernel.org>; Mon, 07 Mar 2022 01:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:subject:references
         :in-reply-to:content-transfer-encoding;
        bh=HqqAvpBRbgPSfhVFPMJLoFf6/CM8KTPGYh0rJOC+Wz4=;
        b=gLPCcKEfN2wsOVU+Rtj1whgP+c/K7HLa+Gwpb5Y9trdi2cPaIygnUNsP1otTl7rvFC
         BZ7KVRfrdUTVlJD/QMMZaePn0Qe5xYY6WZ6TfC2KVqI5OUGko3xkZR/4NSIdx/cDPwQf
         cp6lSMqoc0jg8/4lEaOA4eAi/9huQgZxbIC0ZzoJ+yTwehlOF8pIYzW/eur3mPweGi7E
         WBsbnVfkyeSEaV79095wIyZl7ZXglyKfE7YfjqKRqznXtX9w26klshgn2lBuJ+8ay+D7
         Xg5ayVgrXyCZH2DVMT4+st0GO7lzqYsFRDAkNHOMbfUbV4yH4BF2Onh2gO2Uiip/KVQ5
         uGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :subject:references:in-reply-to:content-transfer-encoding;
        bh=HqqAvpBRbgPSfhVFPMJLoFf6/CM8KTPGYh0rJOC+Wz4=;
        b=ssqupmmuCmspAaQc3WxPbKK06zEPqjjaKeGFW8uF+wYUHlZ24VYPIMEGDm4W0Lwwm/
         VoMaQDwYzBhRbM34m+JQbw/B7XKZkNsnuvJ6mLwwosyMR3Jc0BK9PzrhF/8kt1EgwqjN
         8x6is2HO22CFUVGwGK843CtRFKyWp3+Gui1IRKt0vew7rYLhQpI8gG34I5UWbyAw2lWT
         Z/MGXX+QSMQ/vo3oydCN8oa7wWf3UVeqVL2ufLIy649lhEgDiWmKrSz2EItzqZsxuqm8
         JzNuaM6HHLzOq3NLmfCEVmG44mP6OhqR9cbM+ysJZth8NIq4a/dRHjcw4h6K2FzsB9Oo
         HsYw==
X-Gm-Message-State: AOAM533wvci/4gMzIx9WLvQ/G5IUZyNH5yC9/7IWWnZ8uXe2FtPltnj8
        /7Imb9b4v16e2Q1S9//RsCw=
X-Google-Smtp-Source: ABdhPJws4xGo46FryZ0onOMTKYiaglrN10SL5l/Hmo++8v3Kaf/e6dDUMbYVe5++gEac7jIouohTZw==
X-Received: by 2002:a65:43c8:0:b0:378:7add:ec4c with SMTP id n8-20020a6543c8000000b003787addec4cmr8669831pgp.570.1646644005551;
        Mon, 07 Mar 2022 01:06:45 -0800 (PST)
Received: from [172.20.104.60] ([61.16.102.73])
        by smtp.gmail.com with ESMTPSA id hg1-20020a17090b300100b001bf70e72794sm1658314pjb.40.2022.03.07.01.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 01:06:45 -0800 (PST)
Message-ID: <96ae0c81-c4a4-240c-9d5a-965c4474db2b@gmail.com>
Date:   Mon, 7 Mar 2022 17:06:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
From:   zhangzhen.email@gmail.com
To:     Coly Li <colyli@suse.de>, Nix <nix@esperi.org.uk>,
        linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
Subject: Re: bcache detach lead to xfs force shutdown
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
 <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
 <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
 <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
 <055868d2-1363-da7f-ff4a-d232884d35b9@gmail.com>
 <81a09386-1c4b-810c-a387-c636a0c3d5a5@suse.de>
 <bff3b87d-d8e7-1395-f431-445d98716906@gmail.com>
 <2c6244b9-249a-3379-31b5-f16b3d0cb162@suse.de>
In-Reply-To: <2c6244b9-249a-3379-31b5-f16b3d0cb162@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 3/7/22 4:21 PM, Coly Li <colyli@suse.de> wrote:
> On 3/7/22 3:56 PM, zhangzhen.email@gmail.com wrote:
> 
> >> >>
> >> >> Hold on. Why do you think it should be fixed? As I said, it is >> 
> >> as-designed behavior.
> >> >>
> >> > We use bcache in writearound mode, just cache read io.
> >> > Currently, bcache return io error during detach, randomly lead to
> >> > xfs force shutdown.
> >> >
> >> > After bcache auto detach finished, some dir read write normaly, but
> >> > the others can't read write because of xfs force shutdown.
> >> > This inconsistency confuses filesystem users.
> >>
> >>
> >> Hi Zhen and Nix,
> >>
> >> OK, I come to realize the motivation. Yes you are right, this is an 
> >> awkward issue and good to be fixed.
> >>
> > Hi Coly,
> >
> > So you will pick this patch into your tree ？
> 
> 
> I need to look the patch firstly, could you please post a proposal patch 
> for review ?

Ok.
> 
> 
> Coly Li
> 
> 
