Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A5C48D9B2
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jan 2022 15:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiAMO21 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jan 2022 09:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiAMO21 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jan 2022 09:28:27 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB9CC0223F7
        for <linux-bcache@vger.kernel.org>; Thu, 13 Jan 2022 06:28:26 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m1so20141939lfq.4
        for <linux-bcache@vger.kernel.org>; Thu, 13 Jan 2022 06:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4MT+maaW7KJhHwmqQCGbkCocAW7fIWIVZCbCsyf7Ohw=;
        b=UciQifKQLQbd1TVQUsCaJbcNBUSWnHw7ZO4/YtwVN0Gwozwtgk4exyiRnsTUsWInzf
         xycD8lzYcGXEdF5JsJeBtL9tCH1cKRjneNEFJb1dwzqDRHVc8tTk9vJgBodCe7xjwqvX
         qYpBQtbrKlF1eOzOlAHIW87Jts8bbmKqgrUPBAva/IUFvp87nx0huBdZ06L2N/k4+EEa
         GJ3OPnO9WPvaRJmE8P+1ET95axXtCdidTlSX/9xA42aECqehXmygc6ABRilawd1yr7jr
         +qJTlImSCVlcmgC5nyYGBIrPRqoH+qaMdzIp9d1CaWstBLLiad7VCxgu7+VjxVFsYnM3
         JSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4MT+maaW7KJhHwmqQCGbkCocAW7fIWIVZCbCsyf7Ohw=;
        b=42WyXIpILpAk7nNJRRvImu5jpfTKggX2T9GnRsPjY3PxifOisR4/j/O0Wvl0lmPEOX
         RaXhp2pvE/UgGaxQx1YpNRsIf6iq+015Or3qfK9M4jAY6jFCEYogV+Jr3YnO/dN10Dzr
         QCXKlujMoFGw4IX/KNYIKLIU3bj4k0n3sF3dzcMV7j7THef7NKil+V0rjyU8nMEHL8Y7
         a1vvyFXbocLAZ3E0Vm2AHIepqOH8Sjbv6x7tyJUPBbUcxDucktUelt9aAocPrnVH8qFP
         YRrC2FezCqZXTnk2CADeatGLErFpYaceBMdpjlIlVBEfCkeZzsWU8gTCDtAU8IGIlQOZ
         NQJQ==
X-Gm-Message-State: AOAM530daAaxE8sRT1YH2aC8RDhuUf50Wy3qUhhHyhtujfZqiMlJssl9
        2cQa6Fj/RQ0r5Mzsy03HNLLFLHDNnOX7wFn7iq8=
X-Google-Smtp-Source: ABdhPJzQGI0ff9FxE1Dk6gChzFsuADe9AaFQURhUnYNvejnuXoSPGhVvVUxZ68nO/dlyQasFjQYOlYQr+NPXUI0TAcQ=
X-Received: by 2002:ac2:4d26:: with SMTP id h6mr3466587lfk.332.1642084104968;
 Thu, 13 Jan 2022 06:28:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a19:f204:0:0:0:0:0 with HTTP; Thu, 13 Jan 2022 06:28:24
 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <silvanwaneri@gmail.com>
Date:   Thu, 13 Jan 2022 14:28:24 +0000
Message-ID: <CAJu4-U_A+BmzcpQxYyMG2mW+cOwaG=E3etf5Dp9ZSnegATQasA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Tere! Teavitage, et see teie postkasti saabunud e-kiri ei ole viga,
vaid see oli spetsiaalselt teile adresseeritud. Mul on pakkumine
summas (7 500 000,00 $) mu varalahkunud kliendilt insener Carloselt,
kes kannab teiega sama nime, kes t=C3=B6=C3=B6tas ja elas siin Lome Togos.
elusid. V=C3=B5tan teiega =C3=BChendust kui lahkunu l=C3=A4hisugulasega, et=
 saaksite
n=C3=B5uete alusel raha k=C3=A4tte. P=C3=A4rast teie kiiret reageerimist te=
avitan
teid selle re=C5=BEiimidest
selle lepingu t=C3=A4itmine., v=C3=B5tke minuga sellel e-kirjal =C3=BChendu=
st
(orlandomoris56@gmail.com)
