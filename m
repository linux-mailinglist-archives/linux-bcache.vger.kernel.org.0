Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85831F8B3E
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Jun 2020 00:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgFNWs6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 14 Jun 2020 18:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNWs5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jun 2020 18:48:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D8EC05BD43
        for <linux-bcache@vger.kernel.org>; Sun, 14 Jun 2020 15:48:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id s23so6991164pfh.7
        for <linux-bcache@vger.kernel.org>; Sun, 14 Jun 2020 15:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=odYYJe3FGdrPjfZxDptD/x2hgNUbZ+M5spiQZGUX/DE=;
        b=j6311IhuHKpq4G2m/JCIF9Bkh5vOuknhzJ1J7jWJcCxO85CHRbX0qr+gSV2K/Pj7Iv
         u1LA2NgC2VQfWaqcmaRE2qOfBABa4m3Y/vFmbzPeK9voM52UV1moO4ESFqnZKbo7mxI3
         aUL7/i3TYhlYFCKQxuS40ZAG+S6fHfXhYFdb1ihBy/AAAlKlhBzjrp2aPHJ9sl7ntEfq
         GVqv8aRyM8fAYyAAyeWsHuAK+Iq3qJG9VYlmzk8xMywAkXwRezRdR5hXECozsGnKzyHG
         VnpbNHD0FM7M3sYPJQPs0M0gD3rq6IavEh4zdBM1Yq06CIGSEoyQKf4+XFQpcfy/Nfsm
         GA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=odYYJe3FGdrPjfZxDptD/x2hgNUbZ+M5spiQZGUX/DE=;
        b=pPckKhZaiz+oShf8vPMxtbYVFtg09LmVG4EdUYRArC0xOLt7lBU19JBaCChyLQyaf2
         oMjZcw5pt5TYNxdtWD82o1Ww6fxeSEGG8rak4bqf+TCDxX+0vNDFljlOit4uNR9C+aav
         efEEoJ+T2hS7vrvuzJ8Po0oDNIkWSE/brLH7nfgApbdzxGC9jRtVZs+TyD0MlrhgyUQG
         TqphcHWJH+AQLWHIYovItYY6tyTXYCHag+c8UPF6RRJwEYVso7GQqALxXQYDFp4Efs8D
         WNBMI+jpDXq8t9RAHhpmAfozoGdzRsJR3DksTSVW0QUVXUCRJDe1nDqhX0kn2Y1c/24J
         lGTA==
X-Gm-Message-State: AOAM531jrDiro7flt2x6E5kSWxWOuLkYOK77sghsVKofWWlwLy/NpRgJ
        DWM+cx7m4SGnEh4LnkRUf2z9iw==
X-Google-Smtp-Source: ABdhPJzBwGWakpM2MReXolA9DndxGRQ5h+8rnqDcL3t/V7jtfGFaBmcXe+JTY29VRPOEbeb/Al+hcg==
X-Received: by 2002:a65:4488:: with SMTP id l8mr19020779pgq.327.1592174935249;
        Sun, 14 Jun 2020 15:48:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l187sm11787108pfl.218.2020.06.14.15.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 15:48:54 -0700 (PDT)
Subject: Re: [PATCH 0/4] bcache: more fixes for v5.8-rc1
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200614165333.124999-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <595e3582-980e-6cac-66d6-9ced628239e6@kernel.dk>
Date:   Sun, 14 Jun 2020 16:48:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200614165333.124999-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/14/20 10:53 AM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> Hi Jens,
> 
> Here are more following up fixes for bcache v5.8-rc1.
> 
> The two patches from me are minor clean up. Rested two patches
> are important.
> 
> - Mauricio Faria de Oliveira contributes a fix for a potential
>   kernel panic when users configures improper block size value
>   to bcache backing device. This problem should be fixed as soon
>   as possible IMHO.
> - Zhiqiang Liu contributes a fix for a potential deadlock (even quite
>   hard to trigger), which I want to have it as soon as possible.
> 
> Please take these patches for v5.8-rc1, or -rc2 if it is late for -rc1.

A few hours before -rc1 release is indeed too late. I'd only queue and
push anything this late if there was a very compelling reason to do so.

I've queued them up for -rc2.

-- 
Jens Axboe

